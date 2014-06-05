class Liquider::GeneratedParser

token PIPE DOT DOTDOT COLON COMMA
token TIMES DIV
token PLUS MINUS
token EQ NE LT LE GT GE CONTAINS
token MUSTACHEOPEN MUSTACHECLOSE
token TAGOPEN TAGCLOSE
token PARENOPEN PARENCLOSE
token BRACKETOPEN BRACKETCLOSE

token TEXT IDENT NUMBER STRING TRUE FALSE

rule
  Document:
                        { result = Ast::DocumentNode.new([]) }
  | DocumentElementList { result = Ast::DocumentNode.new([val].flatten) }
  ;

  DocumentElementList:
    DocumentElement
  | DocumentElementList DocumentElement { result = val.flatten }
  ;

  DocumentElement:
    TEXT     { result = Ast::TextNode.new(val[0]) }
  | Mustache
  ;

  Mustache:
    MUSTACHEOPEN Expression MUSTACHECLOSE { result = Ast::MustacheNode.new(val[1]) }
  ;

  Expression:
    ComparisonExpression
  ;

  ComparisonExpression:
    AdditiveExpression
  | ComparisonExpression EQ AdditiveExpression { result = Ast::BinOpNode.new(val[0], val[2], :==) }
  | ComparisonExpression NE AdditiveExpression { result = Ast::BinOpNode.new(val[0], val[2], :!=) }
  | ComparisonExpression LT AdditiveExpression { result = Ast::BinOpNode.new(val[0], val[2], :<) }
  | ComparisonExpression LE AdditiveExpression { result = Ast::BinOpNode.new(val[0], val[2], :<=) }
  | ComparisonExpression GT AdditiveExpression { result = Ast::BinOpNode.new(val[0], val[2], :>) }
  | ComparisonExpression GE AdditiveExpression { result = Ast::BinOpNode.new(val[0], val[2], :>=) }
  | ComparisonExpression CONTAINS AdditiveExpression { result = Ast::BinOpNode.new(val[0], val[2], :contains) }
  ;

  AdditiveExpression:
    MultiplicativeExpression
  | AdditiveExpression PLUS MultiplicativeExpression { result = Ast::BinOpNode.new(val[0], val[2], :+) }
  | AdditiveExpression MINUS MultiplicativeExpression { result = Ast::BinOpNode.new(val[0], val[2], :-) }
  ;

  MultiplicativeExpression:
    CallExpression
  | MultiplicativeExpression TIMES CallExpression { result = Ast::BinOpNode.new(val[0], val[2], :*) }
  | MultiplicativeExpression DIV CallExpression { result = Ast::BinOpNode.new(val[0], val[2], :'/') }
  ;

  CallExpression:
    PrimaryExpression
  | CallExpression DOT IDENT { result = Ast::CallNode.new(val[0], val[2]) }
  | CallExpression BRACKETOPEN Expression BRACKETCLOSE { result = Ast::IndexNode.new(val[0], val[3]) }
  ;

  PrimaryExpression:
    IDENT { result = Ast::SymbolNode.new(val[0]) }
  | STRING { result = Ast::StringNode.new(val[0]) }
  | NUMBER { result = Ast::NumberNode.new(val[0]) }
  | TRUE { result = Ast::BooleanNode.new(true) }
  | FALSE { result = Ast::BooleanNode.new(false) }
  | PARENOPEN Expression PARENCLOSE { result = Ast::ParenthesisedNode.new(val[1]) }
  ;