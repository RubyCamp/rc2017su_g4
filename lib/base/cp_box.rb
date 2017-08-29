# 四角形オブジェクト
class CPBox < CPBase
  def initialize(x, y, w, h, opt = {})
    mass = opt[:mass] || 1  # 質量の定義
    @width = w
    @height = h

    # 中心点の計算
    @w = @width / 2
    @h = @height / 2

    # 頂点定義（順番に意味がある点に留意）
    verts = [
      CP::Vec2.new(-@w, -@h), # 第１頂点（左上）
      CP::Vec2.new(-@w, @h),  # 第２頂点（左下）
      CP::Vec2.new(@w, @h),   # 第３頂点（右下）
      CP::Vec2.new(@w, -@h)   # 第４頂点（右上）
    ]

    # 質量及びサイズ値から慣性モーメント（回転し難さ）を計算
    moment = CP::moment_for_box(mass, w, h)

    # Bodyオブジェクト（性質）生成
    @body = CP::Body.new(mass, 10000)
    @body.p = CP::Vec2.new(x + @w, y + @h)

    # Shapeオブジェクト（形状）生成
    @shape = CP::Shape::Poly.new(@body, verts, CP::Vec2.new(0, 0))

    # Shapeに紐付ける画像を設定
    set_image(opt[:image])
  end

  # Shapeに対応する画像を描画
  # 慣性モーメントによる回転に対応するため、draw_rotを使用。
  # 回転角はBody#a にて取得する。ただし単位がラジアンなので単位変換が必要となっている点に留意
  def draw(rt)
    rt.draw_rot(
      @body.p.x - @w,
      @body.p.y - @h,
      @image,
      @body.a * 180.0 / Math::PI)
  end
end
