class Report
  def initialize(title = 'Report')
    @report = [title + ':']
    @columns = []
    @rows = []
    @spacing_counter = []
  end

  def define_columns(*args)
    if args.length == 0
      raise 'You must define columns'
    end

    @columns = args
    update_spacing(@columns)
    self
  end

  def define_row(*args)
    if args.length != @columns.length
      raise 'Your row information must match the number of columns: ' + @columns.length.to_s
    end

    @rows.push(args)
    update_spacing(args)
    self
  end

  def print_report
    prep_header
    prep_rows

    puts
    @report.each { |k| puts k }
    puts
  end

  def prep_header
    @report.push(prettify_columns)
    @report.push(draw_line)
  end

  def prep_rows
    @report.push(prettify_rows)
  end

  def draw_line
    length = 0

    @spacing_counter.each { |k| length += k }

    # Account for added pipes
    length += 3 * @spacing_counter.length - 2

    '-' * length
  end

  def prettify_columns
    prettify_text(@columns)
  end

  def prettify_rows
    pretty_rows = []
    @rows.each { |k| pretty_rows.push(prettify_text(k)) }
    pretty_rows
  end

  def prettify_text(array)
    pretty_text = ''

    array.each_index { |i|
      pretty_text += array[i].to_s
      if array[i] != array.last
        padding_needed = @spacing_counter[i] - array[i].to_s.length
        pretty_text += ' ' * padding_needed
        pretty_text += ' | '
      end
    }
    pretty_text
  end

  def update_spacing(array)
    if @spacing_counter.length == 0
      array.each_index { |i| @spacing_counter[i] = array[i].length }
    else
      array.each_index { |i|
        length = array[i].to_s.length
        if length > @spacing_counter[i]
          @spacing_counter[i] = length
        end
      }
    end
  end
end
