module SignupsHelper
  def add_new_item_template(field_name, new_object, f, partial_name)
    fields = f.fields_for(field_name, new_object, index: "object_id") do |form|
      render(partial_name, f: form, object: new_object)
    end
    fields.gsub("\n", "")
  end
end
