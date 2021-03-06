module Mosaic
  module Facebook
    module Graph
      class User < Mosaic::Facebook::Graph::GraphObject
        attr_accessor :id, :birthday, :email, :first_name, :gender, :hometown, :last_name, :link, :locale, :location, :name, :username, :oauth_token, :oauth_token_expiry
        attr_name :picture

        def accounts
          @accounts ||= AssociationProxy.new(Mosaic::Facebook::Graph::Account, "/#{id}/accounts")
        end

        def picture
          @picture.is_a?(Hash) ? @picture['data']['url'] : @picture
        end

        def likes
          Mosaic::Facebook::Graph::Like.all(username, :access_token => oauth_token)
        end

        class << self
          def me(options = {})
            find_by_id('me', options)
          end
        end
      end
    end
  end
end
