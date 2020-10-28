# Habit App
Habit App はコミュニティを作成して、仲間と一緒に習慣づけを頑張ることができるサービスです。

<img width="481" alt="2020-10-24" src="https://user-images.githubusercontent.com/64312219/97077868-26c3d700-1622-11eb-8fe6-9f30e155dbd3.png">

## 製作者
渡邊 順一朗

メールアドレス
:e-mail:：junichiro_watanabe@watanavi.com

## URL
[https://habitapp.watanavi.work](https://habitapp.watanavi.work)

右上にある「ログイン」もしくは「新規登録」をクリックして画面遷移した後、
「ゲストユーザとしてログイン」をクリックして頂くとログイン情報無しでログインできます。

## 制作背景
私がこのアプリを作成しようとした理由は、**習慣づけの大変さを少しでも緩和しよう**と考えたからです。

私は2020年4月頃からプログラミング学習を始めたのですが、**毎日継続的に学習をする大変さ**を思い知りました。
学生の頃は強制的に勉強をせざるを得ない環境にありましたが、社会人になった今、日々の業務と並行して**学習を続けるのは難しいこと**でした。
学習に限らず、運動にしても趣味にしても「**習慣づけ**」というのは多くの人にとって難しいことだと思っています。

なぜ習慣づけが大変なのか自分なりに考えたとき、以下のような要素が思い浮かびました。

- モチベーションの維持が難しい
- 自分への甘えが出てしまう
- 達成感が薄く、飽きてしまう

そこで、これら課題を解決するための以下機能を持ったアプリを作ることにしました。

- 同じ目標をもった仲間を見つけられる**コミュニティ機能**
  - 仲間がいることで互いに刺激になり**モチベーションアップ！**

- **仲間の達成状況**を確認できる機能
  - 仲間から見られているという意識を持たせて**自分への甘えを断つ！**

- 達成後は仲間に**アウトプット**できるような機能
  - 仲間にアウトプットすることで**達成感を実感できる！**

私と同じように習慣づけに苦労している方に向けて、その**苦労が緩和できる**ようにと思い作成しました。

## 機能一覧
 - ユーザ登録/検索機能

 - コミュニティ作成/検索機能

 - コミュニティ参加機能(非同期)
   - 気に入ったコミュニティに参加し、参加コミュニティ一覧から確認可能

 - フォロー機能(非同期)
   - ユーザをフォローしてタイムラインから目標達成状況や投稿を確認することが可能

 - 目標達成機能(非同期)
   - コミュニティごとに目標が定められており、達成報告をすることが可能

 - 目標達成後の他ユーザ激励機能(あおり機能)
   - 本日の目標達成した後は他ユーザを激励するための投稿が可能

 - 目標未達成一覧表示機能
   - 本日まだ達成していない目標を一覧で確認可能

 - 激励投稿確認一覧機能
   - 本日他ユーザが投稿した激励投稿を確認可能

 - タイムラインによる他ユーザの目標状況確認機能
   - フォローユーザと同じコミュニティユーザの目標達成状況が表示

 - カレンダーによる達成状況確認機能
   - 目標達成数に応じてカレンダーを色付け
   - カレンダーの日付をクリックすることで、その日達成した目標一覧を表示

 - いいね機能(非同期)
   - 気に入った投稿をいいねし、いいね投稿一覧から確認可能

 - ダイレクトメッセージ機能(非同期)
   - 各ユーザにチャットを模したダイレクトメッセージを送ることが可能

 - 管理者ユーザ機能
   - 管理ユーザはユーザ/コミュニティ/投稿の削除が可能

 - レスポンシブ対応

## 工夫した点

- 直感で操作できるようシンプルなUIにしました。
- マイページを見るだけで過去を含めた状況を確認でき、達成したことを目視できるようにしました。
- 目標達成 ⇒ アウトプット の流れが自然とできるように非同期による画面遷移にしました。
- CI/CD による開発ができるように Docker, ECS/ECR, CircleCI等 を用いて テスト→ビルド→デプロイの自動パイプラインを構築しました。

<img width="332" alt="マイページ" src="https://user-images.githubusercontent.com/64312219/97169248-169c2b00-17cd-11eb-81ac-1decaa4d4265.png">&emsp;<img width="337" alt="目標達成" src="https://user-images.githubusercontent.com/64312219/97169255-1734c180-17cd-11eb-84aa-d218ece5f6ef.png">

## 使用技術
### フロントエンド
 - HTML
 - scss
 - Bootstrap
 - JavaScript
 - React

### バックエンド
 - Ruby 2.6.6
 - Ruby on Rails 6.0.3.2

### インフラ
 - Docker / docker-compose
 - AWS(ECS, ECR, EC2, VPC, ALB, RDS, Route53, ACM, S3)
 - CircleCI(自動テスト、自動ビルド、自動デプロイ)
 - Nginx

### その他
 - Git / GitHub
 - VSCode
 - rspec
 - rubocop
　
## インフラ構成図

![インフラ構成図](https://user-images.githubusercontent.com/64312219/97151125-6a4d4b00-17b2-11eb-8d14-296ff2fb4beb.png)

## E-R図

![E-R図](https://user-images.githubusercontent.com/64312219/97176681-a4c9de80-17d8-11eb-9541-5b739e0f12ff.png)

