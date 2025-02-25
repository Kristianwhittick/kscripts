const SCLASS = ".awsui-popover";
{
  const classArr = document.querySelectorAll(SCLASS);

  console.log(classArr.length);

  for(var i=0; i < classArr.length; i++) { 
    classArr[i].parentNode.removeChild(classArr[i]);
  }
}