class Box < CPBox
  DEFAULT_COLLISION_TYPE = 8
  DEFAULT_E = 0.2
  DEFAULT_U = 0.5

  def initialize(x, y, w, h, opt = {})
    super
    self.shape.e = opt[:shape_e] || DEFAULT_E  # 弾性係数（0.0 - 1.0）
    self.shape.u = opt[:shape_u] || DEFAULT_U  # 摩擦係数（0.0 - 1.0）
    self.shape.collision_type = opt[:collision_type] || DEFAULT_COLLISION_TYPE  # 衝突種別
    @image.set_color_key([255,255,255])
  end
end
