class MemberSet{
  
  public String name;
  public float range;
  //public float[] xi;
  public FuzzySet[] fuzzySets; 
  
  public MemberShipValue[] ruledValues;
  
  public MemberSet(String _name, float _range){
    name = _name;  
    
    fuzzySets = new FuzzySet[0];
    
    if(_range < 0f){
      range = _range * -1;
    }else{
      range = _range;
    }
 
  }
  
  public FuzzySet addFuzzySet(FuzzySet newFuzzySet){
    
    if(fuzzySets == null){
      fuzzySets = new FuzzySet[0];
    }
    
    fuzzySets = (FuzzySet[]) append(fuzzySets, newFuzzySet);
    
    return newFuzzySet;
  }
  
  public float getFuzzyValue(String fuzzyName, float x){
   
    // Find fuzzy named 'fuzzyName' to get f(x)
    for(int i = 0; i < fuzzySets.length; i ++){
    
      if(fuzzySets[i].name.equals(fuzzyName))
        return fuzzySets[i].fx(x);  
    }
    
    
    println("There is no any fuzzy named '" + fuzzyName + "' in member-ship '" + name +"'");
    return 0f;
  }
  
  public MemberShipValue[] getMemberShipValues(float x){
    
    // Error
    if(fuzzySets == null){
      println("No any fuzzy set exist in the member ship named " + name);
      return null;
    }
    
    // Clamp input value
    x = constrain(x, 0f, range);
    
    MemberShipValue[] memberShipValues = new MemberShipValue[fuzzySets.length];
    
    for(int i = 0; i < fuzzySets.length; i++){
      memberShipValues[i] = new MemberShipValue(fuzzySets[i].name, fuzzySets[i].fx(x));
    }
    
    // Display result on the console
    printMemberShipValueInfo(memberShipValues);
    
    return memberShipValues;
  }
  
  private void printMemberShipValueInfo(MemberShipValue[] _memberShipValues){
    
    println("Member set : [" + name +"]");
    
    for(int i = 0; i < _memberShipValues.length; i++){
      String fuzzyName = _memberShipValues[i].fuzzyName;
      float value = _memberShipValues[i].value; 
      
      println("\tFuzzy set name : [" + fuzzyName + "], [" + value + "]");
    }
    
  }
  
  public void takeRule(MemberShipValue[] _memberShipValues){
    
    // Compatibility Shallow - Check 
    if(_memberShipValues.length != fuzzySets.length){
      println("The 'MemberShipValue[]' is not for [" + name + "]");
      return;
    }
    
    // Compatibility Depth - Check 
    for(int i = 0; i < _memberShipValues.length; i++){
      int corrNum = 0;
      
      for(int j = 0; j < fuzzySets.length; j++){
        
        if(_memberShipValues[i].fuzzyName.equals(fuzzySets[j].name))
          corrNum++;
        
      }
      
      // result 
      if(corrNum == 0){
        println("The 'MemberShipValue[]' is not for [" + name + "]");
        return;
      }
      
    }
    
    // Set the member-ship's value as rule's value
    ruledValues = _memberShipValues;
    sortMemberShipValues(ruledValues);
  }
  
  private void sortMemberShipValues(MemberShipValue[] memberShipValues){
 
    // Sort value from less -> much
    for(int focusI = 0; focusI < memberShipValues.length - 1; focusI++){
      for(int compareI = focusI + 1; compareI < memberShipValues.length; compareI ++){
       
        // Compare
        if(memberShipValues[compareI].value < memberShipValues[focusI].value){
          // Swap
          MemberShipValue tmp = memberShipValues[focusI];
          memberShipValues[focusI] = memberShipValues[compareI];
          memberShipValues[compareI] = tmp;
        }
          
      }
    }
    
  }
  
}