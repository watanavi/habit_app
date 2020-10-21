class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :belongs, dependent: :destroy
  has_many :belonging, through: :belongs, source: :group
  has_many :achieving, through: :belongs, source: :achievement
  has_many :groups, dependent: :destroy
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :active_messages, class_name: "Message",
                             foreign_key: "sender_id",
                             dependent: :destroy
  has_many :receivers, through: :active_messages, source: :receiver
  has_many :passive_messages, class_name: "Message",
                              foreign_key: "receiver_id",
                              dependent: :destroy
  has_many :senders, through: :passive_messages, source: :sender
  has_many :likes, dependent: :destroy
  has_many :like_feeds, through: :likes, source: :micropost
  has_one_attached :image
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                                    format: {with: VALID_EMAIL_REGEX},
                                    uniqueness: {case_sensitive: false}
  validates :introduction, length: {maximum: 255}
  has_secure_password
  validates :password, presence: true, length: {minimum: 8}, allow_nil:true
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "形式が無効です" },
                    size:         { less_than: 5.megabytes,
                                    message: "サイズが5MB超過です" }

    def profile_image
      image.variant(resize_to_limit: [150, 150])
    end

    def belong(group)
      belonging << group
      belongs.find_by(group: group).create_achievement
    end

    def belonging?(group)
      belonging.include?(group)
    end

    def leave(group)
      belongs.find_by(group: group).destroy
    end

    def achieved?(group)
      if self.belonging?(group)
        @achievement = achieving.find_by(belong: self.belongs.find_by(group: group))
        if @achievement.histories.find_by(date: Date.today) == nil
          @achievement.update(achieved: false)
        else
          @achievement.update(achieved: true)
        end
        @achievement.achieved
      end
    end

    def not_achieved
      group_ids = []
      belonging.each do |group|
        unless achieved?(group)
          group_ids.push(group.id)
        end
      end
      groups = Group.where("id IN (?)", group_ids)
      array = []
      groups.each do |group|
        props = {
          group_id: group.id,
          group_image: (group.image.attached? ? rails_blob_path(group.image, only_path: true) : "/assets/default-#{group.class.name}.png"),
          group_name: group.name,
          group_path: group_path(group),
          group_habit: group.habit,
          achievement_path: achievement_path(group),
          owner_name: group.user.name,
          owner_path: user_path(group.user),
          member_path: member_group_path(group),
          member_count: group.members.count,
          belong: self.belonging?(group),
          achieved: self.achieved?(group),
        }
        array.push(props)
      end
      return array
    end

    def toggle_achieved(group)
      if achieved?(group)
        @history = History.find_by(achievement: @achievement, date: Date.today)
        @history.destroy unless @history == nil
      else
        if @achievement.histories.find_by(date: Date.today) == nil
          @history = @achievement.histories.create(date: Date.today)
          @history.microposts.create(user: self, content: "#{@history.date} 分の <a href=\"/groups/#{group.id}\">#{group.name}</a> の目標を達成しました。\n目標：#{group.habit}")
        end
      end
      @achievement.toggle!(:achieved) if self.belonging?(group)
    end

    def feed
      following_ids = "SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id"
      group_ids = "SELECT group_id FROM belongs
                   WHERE user_id = :user_id"
      group_members_ids = "SELECT user_id FROM belongs
                           WHERE group_id IN (#{group_ids})"
      belong_ids = "SELECT id FROM belongs
                    WHERE user_id IN (#{following_ids})
                    OR user_id IN (#{group_members_ids})
                    AND group_id IN (#{group_ids})"
      achievement_ids = "SELECT id FROM achievements
                         WHERE belong_id IN (#{belong_ids})"
      history_ids = "SELECT id FROM histories
                     WHERE achievement_id IN (#{achievement_ids})"
      Micropost.where("history_id IN (#{history_ids})",
                       user_id: id, today: Date.today).order("created_at DESC")
    end

    def encouraged_feed
      following_ids = "SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id"
      group_ids = "SELECT group_id FROM belongs
                   WHERE user_id = :user_id"
      group_members_ids = "SELECT user_id FROM belongs
                           WHERE group_id IN (#{group_ids})
                           AND user_id != :user_id"
      belong_ids = "SELECT id FROM belongs
                    WHERE user_id IN (#{following_ids})
                    OR user_id IN (#{group_members_ids})
                    AND group_id IN (#{group_ids})"
      achievement_ids = "SELECT id FROM achievements
                         WHERE belong_id IN (#{belong_ids})"
      history_ids = "SELECT id FROM histories
                     WHERE achievement_id IN (#{achievement_ids})
                     AND date = :today"
      Micropost.where("history_id IN (#{history_ids})
                       AND encouragement = true",
                       user_id: id, today: Date.today).order("created_at DESC")
    end

    def follow(other_user)
      following << other_user
    end

    def unfollow(other_user)
      active_relationships.find_by(followed: other_user).destroy
    end

    def following?(other_user)
      following.include?(other_user)
    end

    def followed_by?(other_user)
      followers.include?(other_user)
    end

    def last_message(user)
      message_ids = "SELECT id FROM messages
                     where sender_id = :current_user_id AND receiver_id = :user_id
                     OR sender_id = :user_id AND receiver_id = :current_user_id"
      Message.where("id IN (#{message_ids})",
                     current_user_id: id, user_id: user.id).order("created_at DESC").limit(1)
    end

    def like(feed)
      like_feeds << feed
    end

    def unlike(feed)
      likes.find_by(micropost: feed).destroy
    end

    def like?(feed)
      like_feeds.include?(feed)
    end

    def achievement_history
      belong_ids = "SELECT id FROM belongs
                    WHERE user_id = :user_id"
      achievement_ids = "SELECT id FROM achievements
                         WHERE belong_id IN (#{belong_ids})"
      histories = History.where("achievement_id IN (#{achievement_ids})", user_id: id)
      hash = {}
      histories.each do |history|
        micropost = history.microposts.find_by(encouragement: false)
        group = history.achievement.belong.group
        props = {
          user_image: (self.image.attached? ? rails_blob_path(self.image, only_path: true) : "/assets/default-#{self.class.name}.png"),
          user_name: self.name,
          user_path: user_path(self),
          group_name: group.name,
          group_path: group_path(group),
          content: micropost.content,
          time: micropost.created_at.strftime("%Y-%m-%d %H:%M"),
          history: history,
          encouragement: micropost.encouragement,
          like_path: like_path(micropost),
          like: self.like?(micropost),
          like_count: micropost.likers.count
        }
        if hash.key?(history.date)
          hash[history.date].push(props)
        else
          hash[history.date] = [props]
        end
      end
      return hash
    end
end
