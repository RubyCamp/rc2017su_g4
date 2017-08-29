class Net <  CPNet
  DEFAULT_COLLISION_TYPE = 6
  DEFAULT_E = 1.0
  DEFAULT_U = 1.0

  attr_accessor :ball

  def initialize(x, y, w, h, opt = {})
    super
    self.shape.e = opt[:shape_e] || DEFAULT_E  # 弾性係数（0.0 - 1.0）
    self.shape.u = opt[:shape_u] || DEFAULT_U  # 摩擦係数（0.0 - 1.0）
    self.shape.collision_type = opt[:collision_type] || DEFAULT_COLLISION_TYPE  # 衝突種別
   @image.set_color_key([255,255,255])

  end

  def draw(rt)
    super
    up_and_down_move
  end

    def up_and_down_move
     if @ball.body.p.x <= 7400 && @ball.body.p.y <= 1200
         @body.v = vec2(0, 1000)
     else
        @body.v = vec2(0, 0)
     end
    end
end
