# fish config -ver Hola 0.1
function fish_prompt
    # Track command execution time
    set -l cmd_duration ""
    if test -n "$CMD_DURATION"
        set -l duration_ms $CMD_DURATION
        if test $duration_ms -gt 5000
            set -l duration_s (math "$duration_ms" / 1000)
            set cmd_duration " $duration_s"s
        end
    end

    # Get current directory
    set -l PROMPT_DIR (prompt_pwd)

    # Get current Git branch with enhanced status
    function parse_git_branch
        git rev-parse --is-inside-work-tree &>/dev/null; or return

        set -l branch (git symbolic-ref --short HEAD 2>/dev/null; or git describe --tags --exact-match 2>/dev/null)
        if test -z "$branch"
            set branch (git rev-parse --short HEAD 2>/dev/null)
        end

        set -l git_status ""
        set -l git_color ""

        # Check repository status
        set -l status_output (git status --porcelain 2>/dev/null)
        set -l ahead_behind (git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null)

        if test -n "$status_output"
            set git_status "✗"
            set git_color "red"
        else if test -n "$ahead_behind"
            set -l ahead (echo $ahead_behind | cut -f1)
            set -l behind (echo $ahead_behind | cut -f2)
            if test "$ahead" -gt 0 -a "$behind" -gt 0
                set git_status "↕"
                set git_color "yellow"
            else if test "$ahead" -gt 0
                set git_status "↑"
                set git_color "green"
            else if test "$behind" -gt 0
                set git_status "↓"
                set git_color "red"
            else
                set git_status "✓"
                set git_color "green"
            end
        else
            set git_status "✓"
            set git_color "green"
        end

        # Check for stashes
        set -l stash_count (git stash list 2>/dev/null | wc -l)
        if test "$stash_count" -gt 0
            set git_status "$git_status≡$stash_count"
        end

        echo "$branch $git_status|$git_color"
    end

    # Detect programming language/framework in current directory
    function detect_language
        # Node.js ecosystem
        if test -f package.json
            if test -f yarn.lock
                echo ""
            else if test -f pnpm-lock.yaml
                echo ""
            else if test -f bun.lockb
                echo ""
            else
                echo ""
            end
            return
        end

        # Python
        if test -f requirements.txt -o -f pyproject.toml -o -f setup.py -o -f Pipfile -o -f poetry.lock
            echo ""
            return
        end
        if test (count *.py) -gt 0
            echo ""
            return
        end

        # Go
        if test -f go.mod -o -f go.sum
            echo ""
            return
        end
        if test (count *.go) -gt 0
            echo ""
            return
        end

        # Rust
        if test -f Cargo.toml -o -f Cargo.lock
            echo ""
            return
        end
        if test (count *.rs) -gt 0
            echo ""
            return
        end

        # Java/Kotlin/Scala
        if test -f build.gradle -o -f build.gradle.kts -o -f pom.xml -o -f build.sbt
            echo ""
            return
        end
        if test (count *.java) -gt 0 -o (count *.kt) -gt 0 -o (count *.scala) -gt 0
            echo ""
            return
        end

        # Ruby
        if test -f Gemfile -o -f Gemfile.lock
            echo ""
            return
        end
        if test (count *.rb) -gt 0
            echo ""
            return
        end

        # PHP
        if test -f composer.json -o -f composer.lock
            echo ""
            return
        end
        if test (count *.php) -gt 0
            echo ""
            return
        end

        # C/C++/C#
        if test -f CMakeLists.txt -o -f makefile -o -f Makefile
            echo ""
            return
        end
        if test (count *.c) -gt 0 -o (count *.cpp) -gt 0 -o (count *.cc) -gt 0 -o (count *.cs) -gt 0
            echo ""
            return
        end

        # TypeScript/JavaScript
        if test (count *.ts) -gt 0 -o (count *.js) -gt 0
            if test -f tsconfig.json
                echo ""
            else
                echo ""
            end
            return
        end

        # Docker/Kubernetes
        if test -f Dockerfile -o -f docker-compose.yml -o -f docker-compose.yaml
            echo ""
            return
        end

        # Configuration files
        if test -f ".env" -o -f ".env.local" -o -f ".env.production"
            echo ""
            return
        end
    end

    # Build optional info block
    function build_info
        set -l git_info (parse_git_branch)
        set -l language (detect_language)
        set -l parts

        if test -n "$language"
            set parts $parts "$language"
        end
        if test -n "$git_info"
            set -l branch (echo $git_info | cut -d'|' -f1)
            set -l color (echo $git_info | cut -d'|' -f2)
            set parts $parts "$branch|$color"
        end

        if test (count $parts) -gt 0
            set_color brblack
            echo -n "["
            set_color normal

            for i in (seq (count $parts))
                set -l part $parts[$i]
                if string match -q "*|*" $part
                    set -l content (echo $part | cut -d'|' -f1)
                    set -l color (echo $part | cut -d'|' -f2)
                    set_color $color
                    echo -n $content
                    set_color normal
                else
                    echo -n $part
                end

                if test $i -lt (count $parts)
                    set_color brblack
                    echo -n " • "
                    set_color normal
                end
            end

            set_color brblack
            echo -n "]"
            set_color normal
        end
    end

    # Show exit status for failed commands
    set -l last_status $status
    if test $last_status -ne 0
        set_color red
        echo -n "[$last_status] "
        set_color normal
    end

    # Main prompt with enhanced styling
    set_color blue
    echo -n "╭─ "
    set_color normal
    set_color brblue
    echo -n "$USER"
    set_color brwhite
    echo -n "@"
    set_color brblue
    echo -n (hostname -s)
    set_color brwhite
    echo -n " in "
    set_color brblue
    echo -n (string replace -- "$HOME" "~" "$PROMPT_DIR")
    set_color normal
    echo -n " "
    build_info
    set_color yellow
    echo -n "$cmd_duration "
    echo
    set_color blue
    echo -n "╰─"
    set_color normal

    # Dynamic prompt symbol based on user privileges
    if test (id -u) -eq 0
        set_color red
        echo -n " # "
    else
        set_color green
        echo -n " ❯ "
    end
    set_color normal
    
end
# Remove the welcome message
function fish_greeting
end

# Set autosuggestion color (command hints from history and system)
set -g fish_color_autosuggestion 5465f7

# alias code=code-insiders
thefuck --alias | source
