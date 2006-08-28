# = Stijgers
# Dutch scaffolding.
module Dutchify # :nodoc:
  module Stijgers # :nodoc:
    def self.append_features(base)
      super
      base.extend(ClassMethods)
    end
    module ClassMethods
      def stijgers(model_id, options = {})
        options.assert_valid_keys(:class_name, :suffix)

        singular_name       = model_id.to_s
        plural_name         = singular_name.pluralize
                            
        class_name          = options[:class_name] || singular_name.camelize
        model_class         = Object.const_get(class_name)

        singular_human_name = model_class.respond_to?(:human_name) ? model_class.human_name : singular_name
        plural_human_name   = singular_human_name.pluralize

        suffix              = options[:suffix] ? "_#{singular_name}" : ""

        unless options[:suffix]
          module_eval <<-"end_eval"
            def index
              list
            end
          end_eval
        end
        
        module_eval <<-"end_eval", __FILE__
          verify :method => :post, :only => [:destroy#{suffix}, :create#{suffix}, :update#{suffix}],
              :redirect_to => {:action => :list#{suffix}}

          def list#{suffix}
            @#{singular_name}_pages, @#{plural_name} = paginate :#{plural_name}, :per_page => 10
            render#{suffix}_scaffold 'list#{suffix}'
          end

          def show#{suffix}
            @#{singular_name} = #{class_name}.find_by_id(params[:id])
            render#{suffix}_scaffold
          end

          def destroy#{suffix}
            #{class_name}.find(params[:id]).destroy
            redirect_to :action => 'list#{suffix}'
          end

          def new#{suffix}
            @#{singular_name} = #{class_name}.new
            render#{suffix}_scaffold
          end

          def create#{suffix}
            if store#{suffix}!
              redirect_to :action => 'list#{suffix}'
            else
              render#{suffix}_scaffold 'new#{suffix}'
            end
          end

          def edit#{suffix}
            @#{singular_name} = #{class_name}.find(params[:id])
            render#{suffix}_scaffold
          end

          def update#{suffix}
            if store#{suffix}!
              redirect_to :action => 'show#{suffix}', :id => @#{singular_name}
            else
              render#{suffix}_scaffold 'edit#{suffix}'
            end
          end

          private
            def store#{suffix}!
              @#{singular_name} = params[:id] ? #{class_name}.find(params[:id]) : #{class_name}.new
              return true unless request.post? && params[:#{singular_name}]

              @#{singular_name}.attributes = params[:#{singular_name}]
              @#{singular_name}.save!

              flash[:notice] = "#{singular_human_name} is \#{params[:id] ? 'aangepast' : 'aangemaakt'}."
              return true
            rescue ActiveRecord::RecordInvalid
              return false
            end

            def render#{suffix}_scaffold(action = action_name)
              if template_exists?("\#{self.class.controller_path}/\#{action}")
                render :action => action
              else
                @scaffold_suffix, @scaffold_class = "#{suffix}", #{class_name}
                @scaffold_singular_name, @scaffold_plural_name = "#{singular_name}", "#{plural_name}"
                @scaffold_singular_human_name, @scaffold_plural_human_name = "#{singular_human_name}", "#{plural_human_name}"

                render :file => scaffold_path(action.sub(/#{suffix}$/, '')), :layout => true
              end
            end

            def scaffold_path(template_name)
              File.dirname(__FILE__) + "/templates/" + template_name + ".rhtml"
            end
        end_eval
      end
      
      alias :scaffold :stijgers
    end
  end
end

module ActionController # :nodoc:
  class Base # :nodoc:
    include Dutchify::Stijgers
  end
end
