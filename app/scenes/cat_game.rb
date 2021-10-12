class CatGame < GTKObject
  FLOOR_IMAGE  = "assets/images/floor.png".freeze
  MOUSE_IMAGE  = "assets/images/mouse.png".freeze
  MOUSE_SCALE  = 0.2
  MOUSE_WIDTH  = 599*MOUSE_SCALE
  MOUSE_HEIGHT = 504*MOUSE_SCALE

  def initialize
    @mouse = geometry.center_inside_rect({ w: MOUSE_WIDTH, h: MOUSE_HEIGHT, path: MOUSE_IMAGE }, grid).sprite!
  end

  def tick
    @angle ||= 0

    render

    current_point = inputs.mouse.point.to_hash

    if @last_point && inputs.mouse.moved
      @angle = geometry.angle_to(@last_point, current_point)
    end

    if current_point.y < grid.bottom.shift_up(MOUSE_WIDTH/2)
      @angle = 90
    elsif current_point.y > grid.top.shift_down(MOUSE_WIDTH/2)
      @angle = 270
    end

    if current_point.x < grid.left.shift_right(MOUSE_WIDTH/2)
      @angle = 0
    elsif current_point.x > grid.right.shift_left(MOUSE_WIDTH/2)
      @angle = 180
    end

    @mouse.merge!(
      x: current_point.x - MOUSE_WIDTH/2,
      y: current_point.y - MOUSE_HEIGHT/2,
      angle: @angle
    )

    @last_point = current_point if @last_point.nil? || geometry.distance(current_point, @last_point) >= 150
  end

  def render
    return if @render

    outputs.static_primitives << { path: FLOOR_IMAGE }.merge(grid.rect.to_hash).sprite!
    outputs.static_primitives << @mouse

    @render = true
  end
end
