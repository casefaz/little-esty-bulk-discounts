# class RepositoryFacade
#   def self.repo_or_error # this is the ternary operator - one liner for a condition
#     json = service.repo
#     json[:message].nil? ? create_repo : json # if json message is nil we're going to return the instance of the repo, otherwise we are  going to return the error message(json) - will call this in the view this whole thing is a conditional for the rate limit
#   end
#
#   def self.create_repo
#     json = service.repo
#     Repository.new(json)
#   end
#
#   def self.contributor_or_error # this is the ternary operator - one liner for a condition
#     json = service.contributor
#     if !json[0].nil? || json[:message].nil?
#       create_contributors
#     end
#   end
#
#   def self.create_contributors
#     json = service.contributor.map do |data|
#       Contributor.new(data)
#     end
#     json.map do |contributor|
#       contributor if [98674727, 98676136, 98354482, 99838997].include?(contributor.id)
#     end.compact
#   end
#
#   def self.merged_or_error
#     json = service.merge
#     # json[:message].nil? ? create_merges : json
#     if !json[0].nil? || json[:message].nil?
#       create_merges
#     end
#   end
#
#   def self.create_merges
#     json = service.merge.map do |data|
#       PullRequest.new(data)
#     end
#     json.count(&:merged_at)
#   end
#
#   def self.create_commits
#     json = {}
#     # json = { user_name: '',
#     #          commits: 0 }
#     create_contributors.each do |con|
#       # json[:user_name] << con.login
#       json[con.login.to_s] = []
#       service.commit(con.login).each do
#         json[con.login.to_s] << Commit.new
#         # json[:commits] += Commit.new(data, con.login)
#       end
#     end
#     json
#   end
#
#   def self.commit_or_error
#     json = service.commit('sage-skaff')
#     # json[:message].nil? ? create_commits : json
#     if !json[0].nil? || json[:message].nil?
#       create_commits
#     end
#   end
#
#   def self.service
#     GithubService.new
#   end
# end
