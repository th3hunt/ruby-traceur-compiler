require 'execjs'
require 'traceur_compiler/source'

module TraceurCompiler
	module Source
		def self.path
			@path ||= ENV['TRACEUR_COMPILER_SOURCE_PATH'] || bundled_path
		end

		def self.path=(path)
			@contents = @context = nil
			@path = path
		end

		def self.contents
			@contents ||= File.read(path)
		end

		def self.context
			return @context unless @context.nil?
			@context = ExecJS.compile(contents)
			@context.exec <<-stubs
				console = {
					error: function () { },
					log: function () { }
				};
			stubs
			@context.exec <<-compile
				compile = function (contents) {
					var project = new traceur.semantics.symbols.Project(''),
						reporter = new traceur.util.ErrorReporter();
					reporter.reportMessageInternal = function (location, format, args) {
						throw new Error(traceur.util.ErrorReporter.format(location, format, args));
					};

					project.addFile(new traceur.syntax.SourceFile('unknown', contents));
					var response = traceur.codegeneration.Compiler.compile(reporter, project, false);
					return traceur.outputgeneration.ProjectWriter.write(response, {});
				}
			compile
			@context
		end
	end

	class << self
		def compile(script)
			script = script.read if script.respond_to?(:read)
			Source.context.call("compile", script)
		end
	end
end
