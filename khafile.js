let project = new Project('Pixel Spirit Elements');
project.addShaders('Sources/Shaders/**');
project.addSources('Sources');
project.windowOptions.width = 800;
project.windowOptions.height = 600;
resolve(project);
