import React from "react"
import PropTypes from "prop-types"
import Belong from "./Belong"
import Achievement from "./Achievement"
import Encouragement from "./Encouragement"
class GroupIntroduction extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      belong: this.props.belong,
      achieved: this.props.achieved,
      memberCount: this.props.member_count
    }
  }

  setBelong = (belong) => {
    this.setState({ belong: belong })
  }

  setAchieved = (achieved) => {
    this.setState({ achieved: achieved })
  }

  setMemberCount = (memberCount) => {
    this.setState({ memberCount: memberCount })
  }

  render() {
    return (
      <React.Fragment>
        <div className="describe">
          <div className="head">
            {this.state.belong ?
              <a className="alert alert-info">
                このコミュニティに参加しています
              </a> : null}
            <div className="menu">
              <img src={this.props.group_image} />
              <ol>
                <li><h3>{this.props.group_name}</h3></li>
                <li>オーナー：<a href={this.props.owner_path}>{this.props.owner_name}</a></li>
                <li>メンバー：<a href={this.props.member_path}>{this.state.memberCount}人が参加</a></li><br />
                <Belong
                  id={this.props.group_id}
                  path={this.props.belong_path}
                  belong={this.state.belong}
                  memberCount={this.state.memberCount}
                  setBelong={this.setBelong}
                  setMemberCount={this.setMemberCount}
                  setAchieved={this.setAchieved} />
              </ol>
              {this.props.owner ?
                <React.Fragment>
                  <ul className="edit">
                    <li><a href={this.props.edit_group_path}>編集する</a></li>
                    <li><a href={this.props.edit_image_group_path}>画像変更する</a></li>
                    <li><a href={this.props.delete_group_path}>削除する</a></li>
                  </ul>
                </React.Fragment> : null}
            </div>
          </div>
          <div className="achievement">
            {this.state.belong ?
              <React.Fragment>
                <h3>
                  本日の目標は
                  {this.state.achieved ? <a class="alert alert-success">達成</a> : <a className="alert alert-danger">未達</a>}
                  です！
                </h3>
                <Achievement
                  id={this.props.group_id}
                  path={this.props.achievement_path}
                  achieved={this.state.achieved}
                  setAchieved={this.setAchieved} />
              </React.Fragment> :
              null}
          </div>
          <div className="encouragement">
            {this.state.achieved ?
              <React.Fragment>
                <Encouragement path={this.props.encouragement_path} />
              </React.Fragment> :
              null}
          </div>
          <div className="body">
            <div>
              <h3>習慣</h3>
              <p>{this.props.group_habit}</p>
            </div>
            <div>
              <h3>概要</h3>
              <p>{this.props.group_overview}</p>
            </div>
          </div>
        </div>
      </React.Fragment>
    );
  }
}

GroupIntroduction.propTypes = {
  group_id: PropTypes.number,
  group_image: PropTypes.string,
  group_name: PropTypes.string,
  group_path: PropTypes.string,
  owner_name: PropTypes.string,
  owner_path: PropTypes.string,
  member_path: PropTypes.string,
  member_count: PropTypes.number,
  group_habit: PropTypes.string,
  group_overview: PropTypes.string,
  belong_path: PropTypes.string,
  achievement_path: PropTypes.string,
  edit_group_path: PropTypes.string,
  edit_image_group_path: PropTypes.string,
  delete_group_path: PropTypes.string,
  belong: PropTypes.bool,
  achieved: PropTypes.bool,
  owner: PropTypes.bool,
  encouragement_path: PropTypes.string
};

export default GroupIntroduction