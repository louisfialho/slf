require File.expand_path('config/environment', __dir__)

require 'metainspector'
page = MetaInspector.new('https://www.reddit.com/r/interestingasfuck/comments/nnfk9m/a_view_of_mt_fuji_from_the_streets_of_fujinomiya/')
p page.best_title
