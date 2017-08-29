class Daruma < CPBox
     DEFAULT_COLLISION_TYPE = 2

  def initialize(x, y, w, h, opt = {})
    super
    self.shape.e = opt[:shape_e] || 0.2
    self.shape.u = opt[:shape_u] || 0.5
    self.shape.collision_type = opt[:collision_type] || DEFAULT_COLLISION_TYPE
    @image.set_color_key([255,255,255])
  end


end
