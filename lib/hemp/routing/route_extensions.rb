module Hemp
  module Routing
    module RouteExtensions
      def resources(*subjects)
        subjects.each do |subject|
          subject_helper subject
        end
      end

      def subject_helper(subject)
        get "/#{subject}", to: "#{subject}#index"
        get "/#{subject}/new", to: "#{subject}#new"
        post "/#{subject}", to: "#{subject}#create"
        get "/#{subject}/:id", to: "#{subject}#show"
        get "/#{subject}/:id/edit", to: "#{subject}#edit"
        patch "/#{subject}/:id", to: "#{subject}#update"
        put "/#{subject}/:id", to: "#{subject}#update"
        delete "/#{subject}/:id", to: "#{subject}#destroy"
      end
    end
  end
end
