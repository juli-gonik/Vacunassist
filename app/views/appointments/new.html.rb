<div class="container mb-5">
  <h1 class="my-5">Registrate para obtener tu vacuna</h1>

  <h2 class="my-5">Datos personales</h2>

  <%= form_with model: @user_patient, url: user_patient_registration_path do |form| %>
    <!-- 2 column grid layout with text inputs for the first and last names -->
    
    <h2 class="my-4 row">Datos de vacunas</h2>
    <div class="row">
      <div class="col">
        <h3>Vacuna COVID</h3>
        <%= form.fields_for :appointments, @covid do |appointment_fields| %>
          <%= appointment_fields.hidden_field :vaccine, value: 'fiebre_amarilla'%>
          <%= appointment_fields.hidden_field :tipo, value: 'pedido'%>
          <%= appointment_fields.hidden_field :status, value: 'pending'%>
          <div class="row mb-4">
            <div class="col">
              <div class="form-outline">
                <%= appointment_fields.label 'Dosis recibidas', class: 'form-label' %>
                <%= appointment_fields.select(:dose, [0,1], {}, class:'form-select') %>
              </div>
            </div>
          </div>
        <%end%>
      </div>
    </div>
    <%=form.submit 'Registrarme', class:'btn btn-primary btn-block mb-4' %>
  <% end %>
</div>
