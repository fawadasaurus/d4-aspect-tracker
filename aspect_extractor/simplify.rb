require 'json'

lothrik_version_file = "../lothrik/VERSION"

version_file_str = File.read(lothrik_version_file)
#1.0.2.42338-3, extract 42338
version = version_file_str.split('-')[0].split('.')[3]

input_codex_file = "../lothrik/parser/codex-values.js"
input_db_file = "../lothrik/database/build-#{version}.json"

output_file = "../app/public/aspects.json"

codex_file_str = File.read(input_codex_file)
codex_file_str.gsub!(/let codexValues = /, '')
codex_file_str.gsub!(/export { codexValues };/, '')

codex_file_json = JSON.parse(codex_file_str)

codex_aspects = []

for pclass in codex_file_json.keys
    if pclass == "Categories"
        next
    end
    for category in codex_file_json[pclass].keys
        for aspect, aspect_details in codex_file_json[pclass][category]
            name = ""
            if aspect.include? "Aspect"
                name = aspect.gsub("Aspect","").strip
            end
            in_codex = false
            if aspect_details["region"] != ""
                in_codex = true
            end
            if in_codex == true
                codex_aspects.push(name)
            end
        end
    end
end

category_map = {"0" => "Offensive", "1" => "Defensive", "2" => "Utility", "3" => "Resource", "4" => "Mobility", "5" => "Weapon"}

db_file_str = File.read(input_db_file)
db_file_json = JSON.parse(db_file_str)

db_aspects = {}

for k, v in db_file_json
    pclass = k
    for aspect, aspect_details in v["Legendary"]
        begin
            category = category_map[aspect_details["category"].to_s]
            name = aspect_details["name"]
            name_localized = aspect_details["name_localized"]
            name_localized["enUS"] = name
            desc_localized = aspect_details["desc_localized"]
            desc_localized["enUS"] = aspect_details["desc"]
            in_codex = codex_aspects.include?(name)
            db_aspects[name] = {"category" => category, "in_codex" => in_codex, "class" => pclass, "name_localized" => name_localized, "desc_localized" => desc_localized}
        rescue => exception
            puts "Error with #{pclass}"
            puts aspect
            puts aspect_details
            puts exception
        end
    end
end

output_json = JSON.pretty_generate(db_aspects)
File.write(output_file, output_json.to_s)