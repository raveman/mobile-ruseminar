

class Lector < ActiveRecord::Base
	has_many :seminars

	def self.import(file)
		# print file.path

		i = 0
		lectors_new = 0
		lectors_updated = 0

		CSV.foreach(file.path, col_sep: ";", encoding: "UTF-8", quote_char: '"') do |row|
			# lector.save!

			if i > 0 
				lector = self.find_by_id(row[1])
				if !lector
					lector = new
					lector.id = row[1]
					lectors_new += 1
				else
					lectors_updated += 1
				end

				lector_names = row[2].split
				if lector_names.length == 2
					lector.last_name = lector_names[1]
					lector.first_name = lector_names[0]
					lector.father_name = ""					
				else
					lector.last_name = lector_names[2]
					lector.first_name = lector_names[0]
					lector.father_name = lector_names[1]
				end

				if lector.last_name.include? 'Ё'
					lector.last_name = lector.last_name.sub('Ё', 'Е')
				end

				if lector.last_name.include? 'ё'
					lector.last_name = lector.last_name.sub('ё','е')
				end

				lector.bio = row[3]
				lector.photo_url = row[4]
				lector.save
			else
				if !row[2].include? "ФИО"
					return Array.new()
				end
			end
			i += 1
		end
		return [lectors_new, lectors_updated]
	end

	def name
		"#{first_name} #{father_name} #{last_name}"
	end

end
