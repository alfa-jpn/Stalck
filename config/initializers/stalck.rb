module Stalck
  def self.config
    @@config ||= OpenStruct.new({
      slack: OpenStruct.new({
        api_url:           nil,
        oauth_url:         nil,
        token:             nil,
        searchable_token:  nil,
        client_id:         nil,
        client_secret_key: nil,
        team_id:           nil,
      })
    })
  end
end

Stalck.config.slack.api_url           = ENV['SLACK_API_URL']
Stalck.config.slack.oauth_url         = ENV['SLACK_OAUTH_URL']
Stalck.config.slack.token             = ENV['SLACK_TOKEN']
Stalck.config.slack.searchable_token  = ENV['SLACK_TOKEN']
Stalck.config.slack.client_id         = ENV['SLACK_CLIENT_ID']
Stalck.config.slack.client_secret_key = ENV['SLACK_CLIENT_SECRET_KEY']
Stalck.config.slack.team_id           = ENV['SLACK_TEAM_ID']
