function save_reproduction(f,experiment)
    projectDir = fileparts(fileparts(mfilename('fullpath')));
    outputDir = fullfile(projectDir,'results',experiment);
    if ~isfolder(outputDir)
        mkdir(outputDir);
    end
    exportgraphics(f,fullfile(outputDir,[experiment '.png']),'Resolution',300);
    savefig(f,fullfile(outputDir,[experiment '.fig']));
end
