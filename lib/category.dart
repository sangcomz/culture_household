String getCategoryText(int category){
  switch(category){
    case 0:{
      return '자기개발📚';
    }
    case 1:{
      return '문화활동🖋';
    }
    case 2:{
      return '운동🤺';
    }
    case 3:{
      return '기타🎸';
    }
    default:{
      return '';
    }
  }
}
