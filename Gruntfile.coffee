module.exports = (grunt) ->
  baseStyles = [
    'src/scss/foundation/bigfoot-variables.scss'
    'src/scss/foundation/bigfoot-mixins.scss'
    'src/scss/base/bigfoot-button.scss'
    'src/scss/base/bigfoot-popover.scss'
  ]
  variants = [
    'bottom'
    'number'
  ]

  concatSet =
    options:
      stripBanners: true
      banner: "// <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today('yyyy.mm.dd') %>\n\n\n"
      separator: "\n\n\n// -----\n\n\n"

    main:
      src: baseStyles
      dest: 'dist/bigfoot-default.scss'

  sassSet = 'dist/bigfoot-default.css': 'dist/bigfoot-default.scss'
  autoprefixSet = 'dist/bigfoot-default.css': 'dist/bigfoot-default.css'

  variants.forEach (variant) ->
    css = "dist/bigfoot-#{variant}.css"
    scss = css.replace('.css', '.scss')
    src = scss.replace('dist/', 'src/scss/variants/')
    conc = baseStyles.slice(0)
    conc.push src
    concatSet[variant] =
      src: conc
      dest: scss

    sassSet[css] = scss
    autoprefixSet[css] = css


  # 1. CONFIG
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    uglify:
      build:
        src: 'dist/bigfoot.js'
        dest: 'dist/bigfoot.min.js'

    concat: concatSet

    coffee:
      dist:
        src: 'src/coffee/bigfoot.coffee'
        dest: 'dist/bigfoot.js'

    sass:
      dist:
        options:
          style: 'expanded'
          sourcemap: 'none'

        files: sassSet

    autoprefixer:
      dist:
        files: autoprefixSet

    watch:
      options:
        livereload: false

      coffee:
        files: ['src/coffee/bigfoot.coffee']
        tasks: ['coffee', 'uglify']
        options:
          spawn: false

      scss:
        files: ['src/**/*.scss']
        tasks: [
          'concat'
          'sass'
          'autoprefixer'
        ]
        options:
          spawn: false


  # 2. TASKS
  require('load-grunt-tasks') grunt

  # 3. PERFORM
  grunt.registerTask 'default', [
    'coffee'
    'uglify'
    'concat'
    'sass'
    'autoprefixer'
  ]

  grunt.registerTask 'styles', [
    'concat'
    'sass'
    'autoprefixer'
  ]

  grunt.registerTask 'scripts', [
    'coffee'
    'uglify'
  ]
