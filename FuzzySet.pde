class FuzzySet{
  
  public String name;
  
  public String functionName;
  
  public float a;
  public float b;
  public float c;
  public float d;
  public float s;
  public float e;
  
  public FuzzySet(String _name,float _a, float _s){
    name = _name;
    
    functionName = "triangular_shape";
    a = _a;
    s = _s;
    
    b = 1f;
  }
  
  public FuzzySet(String _name,float _a, float _b, float _c, float _d){
    name = _name;
    
    functionName = "trapezoidal";
    a = _a;
    b = _b;
    c = _c;
    d = _d;
    
    e = 1f;
  }
  
  public float fx(float x){
    
    if(functionName.equals("trapezoidal")){
      return trapezoidal(x);  
    }
     
    return triangularShape(x);  
  }
  
  private float triangularShape(float x){
    
    if(a - s <= x && x <= a + s ){
      return b * (1 - (abs(x - a) / s)); 
    }
    
    return 0f;
  }
  
  private float trapezoidal(float x){
   
    if(a <= x && x <= b){
      return e * (a - x) / (a - b);
    }else if(b <= x && x <= c){
      return e;
    }else if(c <= x && x <= d){
      return e * (d - x) / (d - c);
    }
    
    return 0f;
  }
  
}