MemberSet memberSet_todoList;
MemberSet memberSet_studyNeeds;
MemberSet memberSet_time;

MemberShipValue[] memberShipValue_todoList;
MemberShipValue[] memberShipValue_studyNeeds;
MemberShipValue[] memberShipValue_time;

void setup(){
  
  // Setup 'todo' member ship
  memberSet_todoList = new MemberSet("todo", 10f);
    memberSet_todoList.addFuzzySet(new FuzzySet("little",-0.1f,0f,2.5f,5f));
    memberSet_todoList.addFuzzySet(new FuzzySet("moderate",5f,2.5f));
    memberSet_todoList.addFuzzySet(new FuzzySet("much",5f,7.5f,10f,10.1f));
  
  // Setup 'study-needs' member ship
  memberSet_studyNeeds = new MemberSet("study-needs", 10f);
    memberSet_studyNeeds.addFuzzySet(new FuzzySet("very little",0f,2.5f));
    memberSet_studyNeeds.addFuzzySet(new FuzzySet("little",2.5f,2.5f));
    memberSet_studyNeeds.addFuzzySet(new FuzzySet("moderate",5f,2.5f));
    memberSet_studyNeeds.addFuzzySet(new FuzzySet("much",7.5f,2.5f));
    memberSet_studyNeeds.addFuzzySet(new FuzzySet("very much",10f,2.5f));
  
  // Setup 'time to go' member ship
  memberSet_time = new MemberSet("time to go", 60f);
    memberSet_time.addFuzzySet(new FuzzySet("go on time",0f,15f));
    memberSet_time.addFuzzySet(new FuzzySet("go late",0f,15f,30f,45f));
    memberSet_time.addFuzzySet(new FuzzySet("go very late",15f,30f,45f,60f));
    memberSet_time.addFuzzySet(new FuzzySet("go bloody late",60f,15f));
    
   Fuzzification(10f, 4f);
   Rule();
   
   float cog = Defuzzification(0.1f);
   println("\ncog = " + cog);
}

void Fuzzification(float todo, float studyNeeds){
  memberShipValue_todoList = memberSet_todoList.getMemberShipValues(todo);
  memberShipValue_studyNeeds = memberSet_studyNeeds.getMemberShipValues(studyNeeds);
}

void Rule(){
  // Rule :
  // 1. if [todo is much] & [study-needs is moderate] then [go late]
  // 2. if [todo is much] & [study-needs is very little] then [go bloody late]
  // 3. if [todo is moderate] & [study-needs is little] then [go very late]
  // 4. if [todo is little] & [study-needs is very much] then [go on time]
  
  // Take Rule -1-
  float rule_1 = min(getFuzzyValue(memberShipValue_todoList, "much"), getFuzzyValue(memberShipValue_studyNeeds, "moderate")); 
  MemberShipValue goLate = new MemberShipValue("go late", rule_1);
  
  // Take Rule -2-
  float rule_2 = min(getFuzzyValue(memberShipValue_todoList, "much"), getFuzzyValue(memberShipValue_studyNeeds, "very little")); 
  MemberShipValue gobloodyLate = new MemberShipValue("go bloody late", rule_2);
  
  // Take Rule -3-
  float rule_3 = min(getFuzzyValue(memberShipValue_todoList, "moderate"), getFuzzyValue(memberShipValue_studyNeeds, "little"));
  MemberShipValue goVeryLate = new MemberShipValue("go very late", rule_3);
  
  // Take Rule -4-
  float rule_4 = min(getFuzzyValue(memberShipValue_todoList, "little"), getFuzzyValue(memberShipValue_studyNeeds, "very much"));
  MemberShipValue goOnTime = new MemberShipValue("go on time", rule_4);
  
  // Take rule to the result member-set
  MemberShipValue[] ruledValues = {goLate, gobloodyLate, goVeryLate, goOnTime};  
  memberSet_time.takeRule(ruledValues);
}

float Defuzzification(float sampling){
  
  // Write fuzzy output on 'float[] y'
  int numberOfIndex = (int)(memberSet_time.range / sampling);
  float[] y = new float[numberOfIndex];
  
  for(int r = 0; r < memberSet_time.ruledValues.length; r++){
    for(int i = 0; i < numberOfIndex; i++){
      float x = i * sampling;
      float fx = memberSet_time.getFuzzyValue(memberSet_time.ruledValues[r].fuzzyName, x);
      
      // Clamp the value
      if(fx > memberSet_time.ruledValues[r].value){
        fx = memberSet_time.ruledValues[r].value;
      }
      
      y[i] = fx;
    }
  }
  
  float sum_yx = 0f; 
  float sum_y = 0f;
    
  // Calculate centroid
  for(int i = 0; i < y.length; i++){
    sum_yx += y[i] * sampling * i;
    sum_y += y[i];
  }
  
  // final result
  if(sum_y == 0f)
    sum_y = 1f;
  
  return  sum_yx / sum_y;
}

float getFuzzyValue(MemberShipValue[] memberShipValues, String name){
  
  for(int i = 0; i < memberShipValues.length; i++){
    if(memberShipValues[i].fuzzyName.equals(name)){
      return memberShipValues[i].value;
    }
  }
  
  println("Not found");
  return 0f;
}