# See: https://github.com/chipmunk-rb/chipmunk/wiki

require 'dxruby'
require 'chipmunk'

require_relative 'director'
require_relative 'lib/base/cp_base'
require_relative 'lib/base/cp_box'
require_relative 'lib/base/cp_circle'
require_relative 'lib/base/cp_static_box'
require_relative 'lib/base/cp_net'

require_relative 'lib/wall'
require_relative 'lib/ball'
require_relative 'lib/box'
require_relative 'lib/daruma'
require_relative 'lib/ira'
require_relative 'lib/Bane'
require_relative 'lib/Warp'
require_relative 'lib/net'
require_relative 'lib/block'
require_relative 'lib/warm'

Window.width = 1000
Window.height = 600

director = Director.new



#オープニングimage
image = Image.load('images/opening.png')
font = Font.new(32)

#オープニング
Window.loop do
  break if Input.key_push?(K_SPACE)
  Window.draw(0,0,image)
  Window.draw_font(370, 560, "Press Space Key", font, color:[245, 83, 14])
end

Window.loop do
  break if Input.key_push?(K_ESCAPE)

  director.play
end
