# Source:
# http://talklikeaduck.denhaven2.com/2011/01/29/automatic-annotation-with-rails-3-with-the-annotate-gem
namespace :ar do
  task :migrate do
    if Padrino.env == :development
      require "annotate/annotate_models"
      AnnotateModels.do_annotations(:position_in_class => 'before', :position_in_fixture => 'before')
    end
  end

  namespace :migrate do
    [:up, :down, :reset, :redo].each do |t|
      task t do
        if Padrino.env == :development
          require "annotate/annotate_models"
          AnnotateModels.do_annotations(:position_in_class => 'before', :position_in_fixture => 'before')
        end
      end
    end
  end
end
