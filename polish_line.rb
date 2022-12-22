def read_next_value(i, s)
    r = ""

    if s[i] =~ /[[:digit:]]/
        while s[i] =~ /[[:digit:]]/ do 
            r << s[i]
            i += 1
        end
    elsif s[i] =~ /[[:alpha:]]/
        puts "Undefined operation"
        exit(1)
    else
        r << s[i]
    end
    
    r
end

def calcul(op, num1, num2)
    res = 0.0

    if op == "+"
        res = num1 + num2
    elsif op == "-"
        res = num1 - num2
    elsif op == "*"
        res = num1 * num2
    elsif op == "/"
        begin
            res = num1 / num2
        rescue ZeroDivisionError => error
            puts error.message
            exit(1)
        end
    elsif op == "^"
        res = num1.pow(num2)
    else
        puts "Undefined operation"
        exit(1)
    end

    res
end

def polish_calculator(polish_string)
    stack = Array.new

    i = 0
    while i < polish_string.length do 
        symbol =  read_next_value(i, polish_string)
        i += symbol.length()

        if symbol =~ /[[:blank:]]/
            next
        end

        if symbol =~ /[[:digit:]]/
            stack.push(symbol)
        else
            a = stack.pop.to_f
            b = stack.pop.to_f
            res = calcul(symbol, b, a)
            stack.push(res)
        end
    end

    stack.pop
end


def parse_in_polish_line(normal_line)
    polish_string = ""
    stack = Array.new
    priority = {
        "(" => 0,
        "+" => 1,
        "-" => 1,
        "*" => 2,
        "/" => 2,
        "^" => 3, 
    }

    i = 0
    while i < normal_line.length do 
        symbol = read_next_value(i, normal_line)
        i += symbol.length()

        if symbol =~ /[[:blank:]]/ 
            next
        end

        if symbol =~ /[[:digit:]]/
            polish_string << symbol << " "
        elsif symbol == "("
            stack.push(symbol)
        elsif symbol == ")"
            while stack.last != "(" do
                polish_string << stack.pop << " "
            end

            stack.pop
        else
            if stack.empty? || 
                priority[stack.last] < priority[symbol]
                stack.push(symbol)
            else
                while !stack.empty? && 
                    priority[stack.last] >= priority[symbol] do
                    polish_string << stack.pop << " "
                end
                
                stack.push(symbol)
            end
        end
    end

    while !stack.empty?
        polish_string << stack.pop
    end

    polish_string
end

puts "Enter math str"
s = gets.chomp

ps = parse_in_polish_line(s)
clps = polish_calculator(ps)

puts ps + " = " + clps.to_s

