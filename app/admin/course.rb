ActiveAdmin.register Course do
  menu label: '课程'
  belongs_to :Coach
  navigation_menu :Coach


end
