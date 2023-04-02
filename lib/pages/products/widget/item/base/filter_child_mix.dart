mixin FilterChildMix {
  //void updateSelected(FilterSelected value);

  bool isSelected = false;

  bool selectedState() => isSelected;

  String getId();

  void drop();

  void dropBase(Function update) {
    if (isSelected) {
      isSelected = false;
      update();
    }
  }
}
