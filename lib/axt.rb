require "axt/version"

module Axt

  module_function def ast_from(code)
    RubyVM::AST.parse(code).children.last
  end

  class Selector
    def initialize(code, ast)
      @code = code
      @ast = ast
    end

    def first_line
      @ast.first_lineno
    end

    def last_line
     @ast.last_lineno
    end

    def first_column
      @ast.first_column
    end

    def last_column
      @ast.last_column
    end

    def expression
      if last_line == first_line
        @code.lines[last_line-1][first_column...last_column]
      else
        (first_line...(last_line+1)).map do |lineno|
          case lineno
          when first_line
            @code.lines[lineno-1][first_column..-1]
          when last_line
            @code.lines[lineno-1][0..last_column]
          else
            @code.lines[lineno-1]
          end
        end.join
      end
    end

    def find_inner_expression _children=children
      _children.each do |n|
        if n.first_line > first_line ||
          n.first_column > first_column
          return n
        elsif n.children.any?
          sub = find_inner_expression(n.children)
          return sub if sub
        end
      end
      nil
    end

    def name
      until_next_expression = find_inner_expression(children)
      if until_next_expression
        last_column_index = until_next_expression.first_column - 1
      else
        last_column_index = -1
      end
      last_column_index -= 1 while @code.lines[first_line-1][last_column_index,1] =~ /[\s=<>]/

      @code.lines[first_line-1][first_column..last_column_index]
    end

    def node_type
      @ast.type.gsub(/NODE_|#{@ast.type}/,'').downcase
    end

    def children
      @ast.children.compact.map do |child|
        case child
        when nil then nil
        else
          self.class.new(@code, child)
        end
      end
    end

    def to_sexp indent: 0
      str = "(#{node_type} #{name}"
      children.each do |child|
        str << "\n"
        str <<  " " * indent
        if child.nil?
          str << 'nil'
        else
          str << child.to_sexp(indent: indent + 1)
        end
      end
      str << ")"
      str
    end
  end

  class Parser
    def initialize(code)
      @code = code
      @ast = Axt.ast_from code
    end

    def selector
      Selector.new(@code, @ast)
    end

    def to_sexp
      selector.to_sexp
    end
  end
end
