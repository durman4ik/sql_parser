module ActionDispatch
  module Routing
    class Mapper
      module Resources
        class Resource
          def collection_name
            plural
          end
        end
      end
    end
  end
end
