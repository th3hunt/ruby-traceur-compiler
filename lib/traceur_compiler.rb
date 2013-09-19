require 'active_support/core_ext/string/inflections'
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
				compile = function (contents, options) {
					for (var key in options) {
						traceur.options[key] = options[key];
					}

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
		def compile(script, options = {})
			script = script.read if script.respond_to?(:read)
			compile_options = Hash[ *options.map { |key, value|
				[key.to_s.camelize(:lower), value]
			}.flatten ]
			Source.context.call("compile", script, compile_options)
		end
	end
end
