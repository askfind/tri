part of trisc;

typedef void Computation(tryte ra, tryte rb, int27 im);

class Registers{
  Map<tryte, Computation> _cache = new Map();

  List<int27> _r = new List(27);
  int get length => _r.length;

  Tril _nz = NULL;
  Tril get nz => _nz;

  void updateNZ(tryte adr){
    int27 x = _r[adr.toInt()];
    _nz = new Tril(x == long(0) ? null : (x > long(0)));
  }

  int27 operator[](tryte adr){
    return _r[adr.toInt()];
  }

  operator[]=(tryte adr, int27 val){
    _r[adr.toInt()] = val;
  }

  IRhandler handler(){
    var def = (Operation op){
      if(op is Reg3){
        var comp = _cache[op.op];
        halt.on(condition: comp != null, code: 126, msg: op.op);
        comp(op.a, op.b, this[op.c]);
        return CPUresult.ok;
      }else if(op is Reg2){
        var comp = _cache[op.op];
        halt.on(condition: comp != null, code: 126, msg: op.op);
        comp(op.a, op.b, op.im);
        return CPUresult.ok;
      }else
        halt.on(msg: op.runtimeType);
    };
    return def;
  }

  void _init(){
    _cache[asm.mov] = (tryte a, tryte b, int27 c){
      this[a] = c;
    };
  }

  Registers(){
    _init();
    for(int i = 0; i<_r.length; i++)
      _r[i] = new int27.zero();
  }
}