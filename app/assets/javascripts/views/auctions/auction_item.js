// (function () {
//   var Views = Compras.Views;
//
//   Views.AuctionItem = Backbone.View.extend({
//     events: {
//       "change input[id$='purchase_solicitation_id']"  : "setMaterials",
//       "change select[id$='purchase_solicitation_kind']" : "setMaterials",
//       "change input[id$='auction_material_id']"  : "setUnidadeAndClass",
//     },
//
//     initialize: function () {
//       this.setElement($('form.auction'));
//
//       this.eventName = 'auction';
//     },
//
//     setup: function () {
//       this.$purchase_id   = this.$("input[id$='purchase_solicitation_id']");
//       this.$purchase_kind = this.$("select[id$='purchase_solicitation_kind']");
//       this.$material = this.$(".auction_material");
//       this.$material_id = this.$("#auction_material_id");
//
//       this.$material
//         .append("<a id='add_new_material' style='float:right' target='_blank' href='"+Routes.new_material+"'>Cadastrar Material</a>");
//     },
//
//     setMaterials: function (event, data) {
//       this.$purchase_kind.find('option[value='+data.kind+']').prop('selected', true);
//
//       if(this.$purchase_id.val() && this.$purchase_kind.val()){
//         $.ajax({
//           url: Routes.purchase_solicitations_api_show,
//           data: {purchase_solicitation_id: this.$purchase_id.val(), by_kind: this.$purchase_kind.val()},
//           dataType: 'json',
//           type: 'GET',
//           success: function (data) {
//             var data_mustache = {
//               uuid: _.uniqueId('fresh-')
//             };
//             var auction_id = $("#auction_id").val();
//             $.each(data.items, function( index, el ){
//               data_mustache['code'] =  el.material.code;
//               data_mustache['material'] =  el.material.description;
//               data_mustache['material_id'] =  el.material.id;
//               data_mustache['detailed_description'] =  el.material.detailed_description;
//               data_mustache['material_class'] =  el.material.material_class ? el.material.material_class.description : '';
//               data_mustache['material_class_id'] =  el.material.material_class_id;
//               data_mustache['reference_unit'] =  el.material.reference_unit ? el.material.reference_unit.acronym : '';
//               data_mustache['quantity'] =  el.quantity;
//               data_mustache['lot'] =  el.lot;
//               data_mustache['estimated_value'] =  '';
//               data_mustache['max_value'] =  '';
//               data_mustache['auction_id'] =  auction_id;
//               data_mustache['id'] =  '';
//               data_mustache['benefit_type'] =  '';
//               data_mustache['group_lot'] =  '';
//
//               $('#auction_items #items-records tbody')
//                 .append($('#auction_items_template').mustache(data_mustache))
//                 .find('tr.total_summary').remove();
//             });
//           }
//         });
//       }},
//
//     setUnidadeAndClass: function(){
//       var material_id = this.$material_id.val();
//       if (material_id) {
//         $.ajax({
//           url: Routes.material_api_show,
//           data: {id: material_id},
//           dataType: 'json',
//           type: 'GET',
//           success: function (data) {
//             var reference_unit = data.reference_unit ? data.reference_unit.acronym : '',
//               material_class = data.material_class ? data.material_class.description : '';
//
//             $('#auction_reference_unit').val(reference_unit);
//             $('#auction_material_class').val(material_class);
//           }
//         });
//       }
//     }
//
//   })
// })();
