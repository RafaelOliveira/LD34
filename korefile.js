var solution = new Solution('LD34');
var project = new Project('LD34');
project.setDebugDir('build/windows');
project.addSubProject(Solution.createProject('build/windows-build'));
project.addSubProject(Solution.createProject('C:/Dev/Projetos/Kha/LD34/Kha'));
project.addSubProject(Solution.createProject('C:/Dev/Projetos/Kha/LD34/Kha/Kore'));
solution.addProject(project);
return solution;
