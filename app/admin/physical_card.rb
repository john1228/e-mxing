ActiveAdmin.register PhysicalCard do
  menu label: '实体卡'
  permit_params :service_id, :virtual_number, :entity_number

  form partial: 'form'
end
