
class OrganiserModel{
  final List organisePossibilities=["year", "month","day","location"];
  var selectedOptions={}; 



  List getAvailableOptions(){
    return  organisePossibilities.where((element) => !selectedOptions.values.contains(element)).toList();
  }

  void addToSelectedOptions(int key,String value){
      selectedOptions[key]=(value);
  }

  void removeToSelectedOptions(int value){
    selectedOptions.remove(value);
  }

}


