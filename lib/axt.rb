require "axt/version"

module Axt

  # Hack node to deconstruct the AST node and use with pattern matching.
  RubyVM::AbstractSyntaxTree::Node.class_eval do
    def name
      children.first
    end

    alias node_type type

    def type
      node_type.to_s.downcase.to_sym
    end

    attr_reader :source

    alias node_children children

    def children
      @children ||= node_children
    end

    def source=(source)
      @source = source
      children.grep(self.class).each do |child|
        child.source = source
      end
    end

    def expression
      if first_lineno == last_lineno
        @source.lines[first_lineno-1][first_column..last_column]
      else
        (first_lineno..last_lineno).map do |line|
          code = @source.lines[line-1]
          if line == first_lineno
            code[first_column..-1]
          elsif line == last_lineno
            code[0..last_column]
          else
            code
          end
        end
      end
    end
    def deconstruct
      [type, children]
    end
    def deconstruct_keys keys
      {type: type, children: children}
    end
  end

  module_function def ast(code)
    ast = RubyVM::AbstractSyntaxTree.parse(code)
    case ast in {type: :scope, children: [*_, ast]}
    else
      ast
    end
    ast.source = code
    ast
  end
end
