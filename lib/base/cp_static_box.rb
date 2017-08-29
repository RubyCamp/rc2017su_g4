class CPStaticBox < CPBase
  def initialize(x, y, w, h, opt = {})
    @x, @y = x, y
    @width, @height = w, h

    # 静的Bodyオブジェクト生成（重力の影響を受けないオブジェクト）
    @body = CP::StaticBody.new
    @body.p = CP::Vec2.new(0, 0)

    # 頂点計算
    verts = [
      CP::Vec2.new(x, y),         # 第１頂点（左上）
      CP::Vec2.new(x, y + h),     # 第２頂点（左下）
      CP::Vec2.new(x + w, y + h), # 第３頂点（右下）
      CP::Vec2.new(x + w, y)      # 第４頂点（右上）
    ]

    # Shapeオブジェクト（形状）生成
    @shape = CP::Shape::Poly.new(@body, verts, CP::Vec2.new(0, 0))

    # Shapeに紐付ける画像設定
    set_image(opt[:image])
  end

  # 描画
  def draw(rt)
    rt.draw(@x, @y, @image)
  end
end
