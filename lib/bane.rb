class Bane < CPStaticBox
  DEFAULT_COLLISION_TYPE = 5
  DEFAULT_E = 1.0
  DEFAULT_U = 1.0

  def initialize(x, y, w, h, opt = {})
    super
    @image.set_color_key([255,255,255])
    self.shape.e = opt[:shape_e] || DEFAULT_E  # 弾性係数（0.0 - 1.0）
    self.shape.u = opt[:shape_u] || DEFAULT_U  # 摩擦係数（0.0 - 1.0）
    self.shape.collision_type = opt[:collision_type] || DEFAULT_COLLISION_TYPE  # 衝突種別
  end
end
