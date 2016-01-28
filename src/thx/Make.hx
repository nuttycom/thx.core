package thx;

import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import haxe.macro.Context;

#if macro
typedef FieldMeta = {
  field: String, 
  type: String, 
  weight: Float, 
  optional: Bool
};
#end

class Make {
  macro public static function constructor(expr : ExprOf<{ expr: ExprDef }>) {
    var items: Array<FieldMeta> = switch expr.expr {
      case EParenthesis({ expr: ECheckType(_, t), pos: pos }): 
        extractFields(t);

      case other:
        Context.error("Make.constructor only accepts anonymous objects with type names as values or a reference to a typedef", Context.currentPos()); [];
    }

    items.sort(function(a, b) return thx.Floats.compare(a.weight, b.weight));

    trace(items);

    var args   = items.map(function(item) return (item.optional ? "?" : "") + '${item.field} : ${item.type}'),
        assign = items.filter(function(item) return !item.optional).map(function(item) return '${item.field} : ${item.field}'),
        types  = items.map(function(item) return (item.optional ? "@:optional " : "") + 'var ${item.field} : ${item.type};'),
        type   = "{ " + types.join(" ") + " }",
        fun    = 'function constructor(${args.join(", ")}) {\n  var obj : $type = {\n    ${assign.join(",\n    ")}\n  };';
    fun += items.filter(function(item) return item.optional).map(function(item) return '\n  if(null != ${item.field}) obj.${item.field} = ${item.field};').join("");
    fun += "\n  return obj;\n}";
    return Context.parse(fun, Context.currentPos());
  }

#if macro
  static function extractFields(typ: ComplexType): Array<FieldMeta> {
    return switch typ {
      case TAnonymous(fields):
        trace("ANON: ##########################################################");
        trace(fields);
        throw("Not yet");
        // thx.Arrays.mapi(
        //   fields, 
        //   function(cf: ClassField, i: Int) return {
        //     field: cf.name,
        //     type: TypeTools.toString(cf.type),
        //     weight: i,
        //     optional: cf.meta.has(":optional")
        //   }
        // );

      case TPath({ name: tName, params: tParams }):
        switch Context.getType(tName) {
          case TType(t, p):
            var type: DefType = t.get();
            var meta: MetaAccess = type.meta;

            switch type.type {
              case TAnonymous(anon):
                // Anonymous, named structural type with potential sequence metadata annotation
                extractAnonFields(anon.get(), meta);

              case _:
                Context.error("Make.constructor can only take a reference to a typedef that represent an object literal", Context.currentPos()); [];
            }

          case _:
            Context.error("Make.constructor can only take a reference to a typedef that represent an object literal", Context.currentPos()); [];
        }

      case _:
        Context.error("Make.constructor can only take a reference to a typedef that represent an object literal", Context.currentPos()); [];
    };
  }

  static function extractAnonFields(anon: AnonType, meta: MetaAccess): Array<FieldMeta> {
    var seqMeta = meta.extract(":sequence");
    var sequence: Array<String> = thx.Arrays.flatMap(seqMeta, function(meta) return meta.params.map(ExprTools.toString));

    return anon.fields.map(extractAnonField.bind(_, sequence));
  }

  static function extractAnonField(field : ClassField, sequence : Array<String>): FieldMeta {
    var weights = thx.Arrays.flatMap(field.meta.extract(":weight"), function(meta) return meta.params).map(ExprTools.toString);
    var pos : Float = if (weights.length > 0) Std.parseFloat(weights[0]) 
                      else sequence.indexOf(field.name);

    trace(field);
    return { 
      field : field.name, 
      type : TypeTools.toString(field.type), 
      weight : pos, 
      optional : field.meta.has(":optional") 
    };
  }

#end
}
