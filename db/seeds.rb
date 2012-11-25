# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Circunscripcion.delete_all
Distrito.delete_all
Region.delete_all

@region = Region.new
@region.numero = 1
@region.nombre= "Arica"
@region.save

Distrito.create(:region_id => @region.id, :numero => 10)
Circunscripcion.create(:region_id => @region.id, :numero => 10)

@region = Region.new
@region.numero = 10
@region.nombre= "Los Lagos"
@region.save

Distrito.create(:region_id => @region.id, :numero => 20)
Circunscripcion.create(:region_id => @region.id, :numero => 20)





