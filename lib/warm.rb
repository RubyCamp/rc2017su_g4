class Warm <  CPNet
  DEFAULT_COLLISION_TYPE = 8
  DEFAULT_E = 1.0
  DEFAULT_U = 1.0

  attr_accessor :ball

  def initialize(x, y, w, h, opt = {})
    super
    self.shape.e = opt[:shape_e] || DEFAULT_E  # 弾性係数（0.0 - 1.0）
    self.shape.u = opt[:shape_u] || DEFAULT_U  # 摩擦係数（0.0 - 1.0）
    self.shape.collision_type = opt[:collision_type] || DEFAULT_COLLISION_TYPE  # 衝突種別
   @image.set_color_key([255,255,255])
   @move = rand(300)
   
  end

  def draw(rt)
   super
   move
  end

private
  def move
     if @ball.body.p.x <= 7000 && @ball.body.p.y <= 1200
        @body.v = vec2(@move - 150, 0)
    else
        @body.v = vec2(0, 0)
    end
  end
end