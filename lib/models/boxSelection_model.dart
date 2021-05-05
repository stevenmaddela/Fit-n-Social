class BoxSelection{
  bool isSelected;
  String title;
  BoxSelection({this.title, this.isSelected});

  void setSelected(bool val){
    isSelected = val;
  }
}