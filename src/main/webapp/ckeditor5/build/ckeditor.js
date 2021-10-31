/*!
 * @license Copyright (c) 2003-2021, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md.
 */
){const o=u[t];const i=e.createPositionAt(n,"end");if(o>0){RL(e,i,o>1?{colspan:o}:null)}t+=Math.abs(o)-1}}}))}insertColumns(t,e={}){const n=this.editor.model;const o=e.at||0;const i=e.columns||1;n.change((e=>{const n=t.getAttribute("headingColumns");if(o<n){e.setAttribute("headingColumns",n+i,t)}const r=this.getColumns(t);if(o===0||r===o){for(const n of t.getChildren()){if(!n.is("element","tableRow")){continue}iR(i,e,e.createPositionAt(n,o?"end":0))}return}const s=new KL(t,{column:o,includeAllSlots:true});for(const t of s){const{row:n,cell:r,cellAnchorColumn:a,cellAnchorRow:c,cellWidth:l,cellHeight:d}=t;if(a<o){e.setAttribute("colspan",l+i,r);const t=c+d-1;for(let e=n;e<=t;e++){s.skipRow(e)}}else{iR(i,e,t.getPositionBefore())}}}))}removeRows(t,e){const n=this.editor.model;const o=e.rows||1;const i=this.getRows(t);const r=e.at;const s=r+o-1;if(s>i-1){throw new u["a"]("tableutils-removerows-row-index-out-of-range",this,{table:t,options:e})}n.change((e=>{const{cellsToMove:n,cellsToTrim:o}=cR(t,r,s);if(n.size){const o=s+1;lR(t,o,n,e)}for(let n=s;n>=r;n--){e.remove(t.getChild(n))}for(const{rowspan:t,cell:n}of o){OL("rowspan",t,n,e)}aR(t,r,s,e);if(!jO(t,this)){FO(t,this)}}))}removeColumns(t,e){const n=this.editor.model;const o=e.at;const i=e.columns||1;const r=e.at+i-1;n.change((e=>{sR(t,{first:o,last:r},e);for(let n=r;n>=o;n--){for(const{cell:o,column:i,cellWidth:r}of[...new KL(t)]){if(i<=n&&r>1&&i+r>n){OL("colspan",r-1,o,e)}else if(i===n){e.remove(o)}}}if(!FO(t,this)){jO(t,this)}}))}splitCellVertically(t,e=2){const n=this.editor.model;const o=t.parent;const i=o.parent;const r=parseInt(t.getAttribute("rowspan")||1);const s=parseInt(t.getAttribute("colspan")||1);n.change((n=>{if(s>1){const{newCellsSpan:o,updatedSpan:i}=rR(s,e);OL("colspan",i,t,n);const a={};if(o>1){a.colspan=o}if(r>1){a.rowspan=r}const c=s>e?e-1:s-1;iR(c,n,n.createPositionAfter(t),a)}if(s<e){const o=e-s;const a=[...new KL(i)];const{column:c}=a.find((({cell:e})=>e===t));const l=a.filter((({cell:e,cellWidth:n,column:o})=>{const i=e!==t&&o===c;const r=o<c&&o+n>c;return i||r}));for(const{cell:t,cellWidth:e}of l){n.setAttribute("colspan",e+o,t)}const d={};if(r>1){d.rowspan=r}iR(o,n,n.createPositionAfter(t),d);const u=i.getAttribute("headingColumns")||0;if(u>c){OL("headingColumns",u+o,i,n)}}}))}splitCellHorizontally(t,e=2){const n=this.editor.model;const o=t.parent;const i=o.parent;const r=i.getChildIndex(o);const s=parseInt(t.getAttribute("rowspan")||1);const a=parseInt(t.getAttribute("colspan")||1);n.change((n=>{if(s>1){const o=[...new KL(i,{startRow:r,endRow:r+s-1,includeAllSlots:true})];const{newCellsSpan:c,updatedSpan:l}=rR(s,e);OL("rowspan",l,t,n);const{column:d}=o.find((({cell:e})=>e===t));const u={};if(c>1){u.rowspan=c}if(a>1){u.colspan=a}for(const t of o){const{column:e,row:o}=t;const i=o>=r+l;const s=e===d;const a=(o+r+l)%c===0;if(i&&s&&a){iR(1,n,t.getPositionBefore(),u)}}}if(s<e){const o=e-s;const c=[...new KL(i,{startRow:0,endRow:r})];for(const{cell:e,cellHeight:i,row:s}of c){if(e!==t&&s+i>r){const t=i+o;n.setAttribute("rowspan",t,e)}}const l={};if(a>1){l.colspan=a}oR(n,i,r+1,o,1,l);const d=i.getAttribute("headingRows")||0;if(d>r){OL("headingRows",d+o,i,n)}}}))}getColumns(t){const e=t.getChild(0);return[...e.getChildren()].reduce(((t,e)=>{const n=parseInt(e.getAttribute("colspan")||1);return t+n}),0)}getRows(t){return Array.from(t.getChildren()).reduce(((t,e)=>e.is("element","tableRow")?t+1:t),0)}}function oR(t,e,n,o,i,r={}){for(let s=0;s<o;s++){const o=t.createElement("tableRow");t.insert(o,e,n);iR(i,t,t.createPositionAt(o,"end"),r)}}function iR(t,e,n,o={}){for(let i=0;i<t;i++){RL(e,n,o)}}function rR(t,e){if(t<e){return{newCellsSpan:1,updatedSpan:1}}const n=Math.floor(t/e);const o=t-n*e+n;return{newCellsSpan:n,updatedSpan:o}}function sR(t,e,n){const o=t.getAttribute("headingColumns")||0;if(o&&e.first<o){const i=Math.min(o-1,e.last)-e.first+1;n.setAttribute("headingColumns",o-i,t)}}function aR(t,e,n,o){const i=t.getAttribute("headingRows")||0;if(e<i){const r=n<i?i-(n-e+1):e;OL("headingRows",r,t,o,0)}}function cR(t,e,n){const o=new Map;const i=[];for(const{row:r,column:s,cellHeight:a,cell:c}of new KL(t,{endRow:n})){const t=r+a-1;const l=r>=e&&r<=n&&t>n;if(l){const t=n-r+1;const e=a-t;o.set(s,{cell:c,rowspan:e})}const d=r<e&&t>=e;if(d){let o;if(t>=n){o=n-e+1}else{o=t-e+1}i.push({cell:c,rowspan:a-o})}}return{cellsToMove:o,cellsToTrim:i}}function lR(t,e,n,o){const i=new KL(t,{includeAllSlots:true,row:e});const r=[...i];const s=t.getChild(e);let a;for(const{column:t,cell:e,isAnchor:i}of r){if(n.has(t)){const{cell:e,rowspan:i}=n.get(t);const r=a?o.createPositionAfter(a):o.createPositionAt(s,0);o.move(o.createRangeOn(e),r);OL("rowspan",i,e,o);a=e}else if(i){a=e}}}class dR extends Wn{refresh(){const t=kO(this.editor.model.document.selection);this.isEnabled=_O(t,this.editor.plugins.get(nR))}execute(){const t=this.editor.model;const e=this.editor.plugins.get(nR);t.change((n=>{const o=kO(t.document.selection);const i=o.shift();const{mergeWidth:r,mergeHeight:s}=fR(i,o,e);OL("colspan",r,i,n);OL("rowspan",s,i,n);for(const t of o){uR(t,i,n)}const a=i.findAncestor("table");VO(a,e);n.setSelection(i,"in")}))}}function uR(t,e,n){if(!hR(t)){if(hR(e)){n.remove(n.createRangeIn(e))}n.move(n.createRangeIn(t),n.createPositionAt(e,"end"))}n.remove(t)}function hR(t){return t.childCount==1&&t.getChild(0).is("element","paragraph")&&t.getChild(0).isEmpty}function fR(t,e,n){let o=0;let i=0;for(const t of e){const{row:e,column:r}=n.getCellLocation(t);o=gR(t,r,o,"colspan");i=gR(t,e,i,"rowspan")}const{row:r,column:s}=n.getCellLocation(t);const a=o-s;const c=i-r;return{mergeWidth:a,mergeHeight:c}}function gR(t,e,n,o){const i=parseInt(t.getAttribute(o)||1);return Math.max(n,e+i)}class mR extends Wn{refresh(){const t=wO(this.editor.model.document.selection);this.isEnabled=t.length>0}execute(){const t=this.editor.model;const e=wO(t.document.selection);const n=CO(e);const o=e[0].findAncestor("table");const i=[];for(let e=n.first;e<=n.last;e++){for(const n of o.getChild(e).getChildren()){i.push(t.createRangeOn(n))}}t.change((t=>{t.setSelection(i)}))}}class pR extends Wn{refresh(){const t=wO(this.editor.model.document.selection);this.isEnabled=t.length>0}execute(){const t=this.editor.model;const e=wO(t.document.selection);const n=e[0];const o=e.pop();const i=n.findAncestor("table");const r=this.editor.plugins.get("TableUtils");const s=r.getCellLocation(n);const a=r.getCellLocation(o);const c=Math.min(s.column,a.column);const l=Math.max(s.column,a.column);const d=[];for(const e of new KL(i,{startColumn:c,endColumn:l})){d.push(t.createRangeOn(e.cell))}t.change((t=>{t.setSelection(d)}))}}function kR(t){t.document.registerPostFixer((e=>bR(e,t)))}function bR(t,e){const n=e.document.differ.getChanges();let o=false;const i=new Set;for(const e of n){let n;if(e.name=="table"&&e.type=="insert"){n=e.position.nodeAfter}if(e.name=="tableRow"||e.name=="tableCell"){n=e.position.findAncestor("table")}if(vR(e)){n=e.range.start.findAncestor("table")}if(n&&!i.has(n)){o=wR(n,t)||o;o=CR(n,t)||o;i.add(n)}}return o}function wR(t,e){let n=false;const o=AR(t);if(o.length){n=true;for(const t of o){OL("rowspan",t.rowspan,t.cell,e,1)}}return n}function CR(t,e){let n=false;const o=_R(t);const i=[];for(const[e,n]of o.entries()){if(!n&&t.getChild(e).is("element","tableRow")){i.push(e)}}if(i.length){n=true;for(const n of i.reverse()){e.remove(t.getChild(n));o.splice(n,1)}}const r=o.filter(((e,n)=>t.getChild(n).is("element","tableRow")));const s=r[0];const a=r.every((t=>t===s));if(!a){const o=r.reduce(((t,e)=>e>t?e:t),0);for(const[i,s]of r.entries()){const r=o-s;if(r){for(let n=0;n<r;n++){RL(e,e.createPositionAt(t.getChild(i),"end"))}n=true}}}return n}function AR(t){const e=parseInt(t.getAttribute("headingRows")||0);const n=Array.from(t.getChildren()).reduce(((t,e)=>e.is("element","tableRow")?t+1:t),0);const o=[];for(const{row:i,cell:r,cellHeight:s}of new KL(t)){if(s<2){continue}const t=i<e;const a=t?e:n;if(i+s>a){const t=a-i;o.push({cell:r,rowspan:t})}}return o}function _R(t){const e=new Array(t.childCount).fill(0);for(const{rowIndex:n}of new KL(t,{includeAllSlots:true})){e[n]++}return e}function vR(t){const e=t.type==="attribute";const n=t.attributeKey;return e&&(n==="headingRows"||n==="colspan"||n==="rowspan")}function yR(t){t.document.registerPostFixer((e=>xR(e,t)))}function xR(t,e){const n=e.document.differ.getChanges();let o=false;for(const e of n){if(e.type=="insert"&&e.name=="table"){o=ER(e.position.nodeAfter,t)||o}if(e.type=="insert"&&e.name=="tableRow"){o=DR(e.position.nodeAfter,t)||o}if(e.type=="insert"&&e.name=="tableCell"){o=IR(e.position.nodeAfter,t)||o}if(TR(e)){o=IR(e.position.parent,t)||o}}return o}function ER(t,e){let n=false;for(const o of t.getChildren()){if(o.is("element","tableRow")){n=DR(o,e)||n}}return n}function DR(t,e){let n=false;for(const o of t.getChildren()){n=IR(o,e)||n}return n}function IR(t,e){if(t.childCount==0){e.insertElement("paragraph",t);return true}const n=Array.from(t.getChildren()).filter((t=>t.is("$text")));for(const t of n){e.wrap(e.createRangeOn(t),"paragraph")}return!!n.length}function TR(t){if(!t.position||!t.position.parent.is("element","tableCell")){return false}return t.type=="insert"&&t.name=="$text"||t.type=="remove"}function MR(t,e){t.document.registerPostFixer((()=>SR(t.document.differ,e)))}function SR(t,e){const n=new Set;for(const e of t.getChanges()){const t=e.type=="attribute"?e.range.start.parent:e.position.parent;if(t.is("element","tableCell")){n.add(t)}}for(const o of n.values()){for(const n of[...o.getChildren()].filter((t=>NR(t,e)))){t.refreshItem(n)}}return false}function NR(t,e){if(!t.is("element","paragraph")){return false}const n=e.toViewElement(t);if(!n){return false}return eO(t)!==n.is("element","span")}function BR(t){t.document.registerPostFixer((()=>zR(t)))}function zR(t){const e=t.document.differ;const n=new Set;for(const t of e.getChanges()){if(t.type!="attribute"){continue}const e=t.range.start.nodeAfter;if(e&&e.is("element","table")&&t.attributeKey=="headingRows"){n.add(e)}}if(n.size){for(const t of n.values()){e.refreshItem(t)}return true}return false}var PR=n(63);var LR={injectType:"singletonStyleTag",attributes:{"data-cke":true}};LR.insert="head";LR.singleton=true;var OR=Sb()(PR["a"],LR);var RR=PR["a"].locals||{};class jR extends Un{static get pluginName(){return"TableEditing"}init(){const t=this.editor;const e=t.model;const n=e.schema;const o=t.conversion;n.register("table",{allowWhere:"$block",allowAttributes:["headingRows","headingColumns"],isObject:true,isBlock:true});n.register("tableRow",{allowIn:"table",isLimit:true});n.register("tableCell",{allowIn:"tableRow",allowChildren:"$block",allowAttributes:["colspan","rowspan"],isLimit:true,isSelectable:true});o.for("upcast").add(FL());o.for("upcast").add(VL());o.for("editingDowncast").add($L({asWidget:true}));o.for("dataDowncast").add($L());o.for("upcast").elementToElement({model:"tableRow",view:"tr"});o.for("upcast").add(UL());o.for("editingDowncast").add(QL());o.for("editingDowncast").add(XL());o.for("upcast").elementToElement({model:"tableCell",view:"td"});o.for("upcast").elementToElement({model:"tableCell",view:"th"});o.for("upcast").add(HL("td"));o.for("upcast").add(HL("th"));o.for("editingDowncast").add(JL());o.for("editingDowncast").elementToElement({model:"paragraph",view:tO,converterPriority:"high"});o.attributeToAttribute({model:"colspan",view:"colspan"});o.attributeToAttribute({model:"rowspan",view:"rowspan"});o.for("editingDowncast").add(ZL());t.commands.add("insertTable",new mO(t));t.commands.add("insertTableRowAbove",new TO(t,{order:"above"}));t.commands.add("insertTableRowBelow",new TO(t,{order:"below"}));t.commands.add("insertTableColumnLeft",new MO(t,{order:"left"}));t.commands.add("insertTableColumnRight",new MO(t,{order:"right"}));t.commands.add("removeTableRow",new $O(t));t.commands.add("removeTableColumn",new JO(t));t.commands.add("splitTableCellVertically",new SO(t,{direction:"vertically"}));t.commands.add("splitTableCellHorizontally",new SO(t,{direction:"horizontally"}));t.commands.add("mergeTableCells",new dR(t));t.commands.add("mergeTableCellRight",new WO(t,{direction:"right"}));t.commands.add("mergeTableCellLeft",new WO(t,{direction:"left"}));t.commands.add("mergeTableCellDown",new WO(t,{direction:"down"}));t.commands.add("mergeTableCellUp",new WO(t,{direction:"up"}));t.commands.add("setTableColumnHeader",new eR(t));t.commands.add("setTableRowHeader",new tR(t));t.commands.add("selectTableRow",new mR(t));t.commands.add("selectTableColumn",new pR(t));BR(e);kR(e);MR(e,t.editing.mapper);yR(e)}static get requires(){return[nR]}}var FR=n(64);var VR={injectType:"singletonStyleTag",attributes:{"data-cke":true}};VR.insert="head";VR.singleton=true;var UR=Sb()(FR["a"],VR);var HR=FR["a"].locals||{};class WR extends Lb{constructor(t){super(t);const e=this.bindTemplate;this.items=this._createGridCollection();this.set("rows",0);this.set("columns",0);this.bind("label").to(this,"columns",this,"rows",((t,e)=>`${e} × ${t}`));this.setTemplate({tag:"div",attributes:{class:["ck"]},children:[{tag:"div",attributes:{class:["ck-insert-table-dropdown__grid"]},on:{"mouseover@.ck-insert-table-dropdown-grid-box":e.to("boxover")},children:this.items},{tag:"div",attributes:{class:["ck-insert-table-dropdown__label"]},children:[{text:e.to("label")}]}],on:{mousedown:e.to((t=>{t.preventDefault()})),click:e.to((()=>{this.fire("execute")}))}});this.on("boxover",((t,e)=>{const{row:n,column:o}=e.target.dataset;this.set({rows:parseInt(n),columns:parseInt(o)})}));this.on("change:columns",(()=>{this._highlightGridBoxes()}));this.on("change:rows",(()=>{this._highlightGridBoxes()}))}focus(){}focusLast(){}_highlightGridBoxes(){const t=this.rows;const e=this.columns;this.items.map(((n,o)=>{const i=Math.floor(o/10);const r=o%10;const s=i<t&&r<e;n.set("isOn",s)}))}_createGridCollection(){const t=[];for(let e=0;e<100;e++){const n=Math.floor(e/10);const o=e%10;t.push(new qR(this.locale,n+1,o+1))}return this.createCollection(t)}}class qR extends Lb{constructor(t,e,n){super(t);const o=this.bindTemplate;this.set("isOn",false);this.setTemplate({tag:"div",attributes:{class:["ck-insert-table-dropdown-grid-box",o.if("isOn","ck-on")],"data-row":e,"data-column":n}})}}var GR='<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M3 6v3h4V6H3zm0 4v3h4v-3H3zm0 4v3h4v-3H3zm5 3h4v-3H8v3zm5 0h4v-3h-4v3zm4-4v-3h-4v3h4zm0-4V6h-4v3h4zm1.5 8a1.5 1.5 0 0 1-1.5 1.5H3A1.5 1.5 0 0 1 1.5 17V4c.222-.863 1.068-1.5 2-1.5h13c.932 0 1.778.637 2 1.5v13zM12 13v-3H8v3h4zm0-4V6H8v3h4z"/></svg>';var KR='<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M2.5 1h15A1.5 1.5 0 0 1 19 2.5v15a1.5 1.5 0 0 1-1.5 1.5h-15A1.5 1.5 0 0 1 1 17.5v-15A1.5 1.5 0 0 1 2.5 1zM2 2v16h16V2H2z" opacity=".6"/><path d="M18 7v1H2V7h16zm0 5v1H2v-1h16z" opacity=".6"/><path d="M14 1v18a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V1a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1zm-2 1H8v4h4V2zm0 6H8v4h4V8zm0 6H8v4h4v-4z"/></svg>';var YR='<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M2.5 1h15A1.5 1.5 0 0 1 19 2.5v15a1.5 1.5 0 0 1-1.5 1.5h-15A1.5 1.5 0 0 1 1 17.5v-15A1.5 1.5 0 0 1 2.5 1zM2 2v16h16V2H2z" opacity=".6"/><path d="M7 2h1v16H7V2zm5 0h1v16h-1V2z" opacity=".6"/><path d="M1 6h18a1 1 0 0 1 1 1v6a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1V7a1 1 0 0 1 1-1zm1 2v4h4V8H2zm6 0v4h4V8H8zm6 0v4h4V8h-4z"/></svg>';var $R='<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M2.5 1h15A1.5 1.5 0 0 1 19 2.5v15a1.5 1.5 0 0 1-1.5 1.5h-15A1.5 1.5 0 0 1 1 17.5v-15A1.5 1.5 0 0 1 2.5 1zM2 2v16h16V2H2z" opacity=".6"/><path d="M7 2h1v16H7V2zm5 0h1v7h-1V2zm6 5v1H2V7h16zM8 12v1H2v-1h6z" opacity=".6"/><path d="M7 7h12a1 1 0 0 1 1 1v11a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V8a1 1 0 0 1 1-1zm1 2v9h10V9H8z"/></svg>';class QR extends Un{static get pluginName(){return"TableUI"}init(){const t=this.editor;const e=this.editor.t;const n=t.locale.contentLanguageDirection;const o=n==="ltr";t.ui.componentFactory.add("insertTable",(n=>{const o=t.commands.get("insertTable");const i=OC(n);i.bind("isEnabled").to(o);i.buttonView.set({icon:GR,label:e("Insert table"),tooltip:true});let r;i.on("change:isOpen",(()=>{if(r){return}r=new WR(n);i.panelView.children.add(r);r.delegate("execute").to(i);i.buttonView.on("open",(()=>{r.rows=0;r.columns=0}));i.on("execute",(()=>{t.execute("insertTable",{rows:r.rows,columns:r.columns});t.editing.view.focus()}))}));return i}));t.ui.componentFactory.add("tableColumn",(t=>{const n=[{type:"switchbutton",model:{commandName:"setTableColumnHeader",label:e("Header column"),bindIsOn:true}},{type:"separator"},{type:"button",model:{commandName:o?"insertTableColumnLeft":"insertTableColumnRight",label:e("Insert column left")}},{type:"button",model:{commandName:o?"insertTableColumnRight":"insertTableColumnLeft",label:e("Insert column right")}},{type:"button",model:{commandName:"removeTableColumn",label:e("Delete column")}},{type:"button",model:{commandName:"selectTableColumn",label:e("Select column")}}];return this._prepareDropdown(e("Column"),KR,n,t)}));t.ui.componentFactory.add("tableRow",(t=>{const n=[{type:"switchbutton",model:{commandName:"setTableRowHeader",label:e("Header row"),bindIsOn:true}},{type:"separator"},{type:"button",model:{commandName:"insertTableRowAbove",label:e("Insert row above")}},{type:"button",model:{commandName:"insertTableRowBelow",label:e("Insert row below")}},{type:"button",model:{commandName:"removeTableRow",label:e("Delete row")}},{type:"button",model:{commandName:"selectTableRow",label:e("Select row")}}];return this._prepareDropdown(e("Row"),YR,n,t)}));t.ui.componentFactory.add("mergeTableCells",(t=>{const n=[{type:"button",model:{commandName:"mergeTableCellUp",label:e("Merge cell up")}},{type:"button",model:{commandName:o?"mergeTableCellRight":"mergeTableCellLeft",label:e("Merge cell right")}},{type:"button",model:{commandName:"mergeTableCellDown",label:e("Merge cell down")}},{type:"button",model:{commandName:o?"mergeTableCellLeft":"mergeTableCellRight",label:e("Merge cell left")}},{type:"separator"},{type:"button",model:{commandName:"splitTableCellVertically",label:e("Split cell vertically")}},{type:"button",model:{commandName:"splitTableCellHorizontally",label:e("Split cell horizontally")}}];return this._prepareMergeSplitButtonDropdown(e("Merge cells"),$R,n,t)}))}_prepareDropdown(t,e,n,o){const i=this.editor;const r=OC(o);const s=this._fillDropdownWithListOptions(r,n);r.buttonView.set({label:t,icon:e,tooltip:true});r.bind("isEnabled").toMany(s,"isEnabled",((...t)=>t.some((t=>t))));this.listenTo(r,"execute",(t=>{i.execute(t.source.commandName);i.editing.view.focus()}));return r}_prepareMergeSplitButtonDropdown(t,e,n,o){const i=this.editor;const r=OC(o,$w);const s="mergeTableCells";const a=i.commands.get(s);const c=this._fillDropdownWithListOptions(r,n);r.buttonView.set({label:t,icon:e,tooltip:true,isEnabled:true});r.bind("isEnabled").toMany([a,...c],"isEnabled",((...t)=>t.some((t=>t))));this.listenTo(r.buttonView,"execute",(()=>{i.execute(s);i.editing.view.focus()}));this.listenTo(r,"execute",(t=>{i.execute(t.source.commandName);i.editing.view.focus()}));return r}_fillDropdownWithListOptions(t,e){const n=this.editor;const o=[];const i=new ba;for(const t of e){JR(t,n,o,i)}jC(t,i,n.ui.componentFactory);return o}}function JR(t,e,n,o){const i=t.model=new _A(t.model);const{commandName:r,bindIsOn:s}=t.model;if(t.type==="button"||t.type==="switchbutton"){const t=e.commands.get(r);n.push(t);i.set({commandName:r});i.bind("isEnabled").to(t);if(s){i.bind("isOn").to(t,"value")}}i.set({withText:true});o.add(t)}var ZR=n(65);var XR={injectType:"singletonStyleTag",attributes:{"data-cke":true}};XR.insert="head";XR.singleton=true;var tj=Sb()(ZR["a"],XR);var ej=ZR["a"].locals||{};class nj extends Un{static get pluginName(){return"TableSelection"}static get requires(){return[nR]}init(){const t=this.editor;const e=t.model;this.listenTo(e,"deleteContent",((t,e)=>this._handleDeleteContent(t,e)),{priority:"high"});this._defineSelectionConverter();this._enablePluginDisabling()}getSelectedTableCells(){const t=this.editor.model.document.selection;const e=kO(t);if(e.length==0){return null}return e}getSelectionAsFragment(){const t=this.getSelectedTableCells();if(!t){return null}return this.editor.model.change((e=>{const n=e.createDocumentFragment();const o=this.editor.plugins.get("TableUtils");const{first:i,last:r}=AO(t);const{first:s,last:a}=CO(t);const c=t[0].findAncestor("table");let l=a;let d=r;if(_O(t,o)){const t={firstColumn:i,lastColumn:r,firstRow:s,lastRow:a};l=UO(c,t);d=HO(c,t)}const u={startRow:s,startColumn:i,endRow:l,endColumn:d};const h=NO(c,u,e);e.insert(h,n,0);return n}))}setCellSelection(t,e){const n=this._getCellsToSelect(t,e);this.editor.model.change((t=>{t.setSelection(n.cells.map((e=>t.createRangeOn(e))),{backward:n.backward})}))}getFocusCell(){const t=this.editor.model.document.selection;const e=[...t.getRanges()].pop();const n=e.getContainedElement();if(n&&n.is("element","tableCell")){return n}return null}getAnchorCell(){const t=this.editor.model.document.selection;const e=Cf(t.getRanges());const n=e.getContainedElement();if(n&&n.is("element","tableCell")){return n}return null}_defineSelectionConverter(){const t=this.editor;const e=new Set;t.conversion.for("editingDowncast").add((t=>t.on("selection",((t,o,i)=>{const r=i.writer;n(r);const s=this.getSelectedTableCells();if(!s){return}for(const t of s){const n=i.mapper.toViewElement(t);r.addClass("ck-editor__editable_selected",n);e.add(n)}const a=i.mapper.toViewElement(s[s.length-1]);r.setSelection(a,0)}),{priority:"lowest"})));function n(t){for(const n of e){t.removeClass("ck-editor__editable_selected",n)}e.clear()}}_enablePluginDisabling(){const t=this.editor;this.on("change:isEnabled",(()=>{if(!this.isEnabled){const e=this.getSelectedTableCells();if(!e){return}t.model.change((n=>{const o=n.createPositionAt(e[0],0);const i=t.model.schema.getNearestSelectionRange(o);n.setSelection(i)}))}}))}_handleDeleteContent(t,e){const[n,o]=e;const i=this.editor.model;const r=!o||o.direction=="backward";const s=kO(n);if(!s.length){return}t.stop();i.change((t=>{const e=s[r?s.length-1:0];i.change((t=>{for(const e of s){i.deleteContent(t.createSelection(e,"in"))}}));const o=i.schema.getNearestSelectionRange(t.createPositionAt(e,0));if(n.is("documentSelection")){t.setSelection(o)}else{n.setTo(o)}}))}_getCellsToSelect(t,e){const n=this.editor.plugins.get("TableUtils");const o=n.getCellLocation(t);const i=n.getCellLocation(e);const r=Math.min(o.row,i.row);const s=Math.max(o.row,i.row);const a=Math.min(o.column,i.column);const c=Math.max(o.column,i.column);const l=new Array(s-r+1).fill(null).map((()=>[]));const d={startRow:r,endRow:s,startColumn:a,endColumn:c};for(const{row:e,cell:n}of new KL(t.findAncestor("table"),d)){l[e-r].push(n)}const u=i.row<o.row;const h=i.column<o.column;if(u){l.reverse()}if(h){l.forEach((t=>t.reverse()))}return{cells:l.flat(),backward:u||h}}}class oj extends Un{static get pluginName(){return"TableClipboard"}static get requires(){return[nj,nR]}init(){const t=this.editor;const e=t.editing.view.document;this.listenTo(e,"copy",((t,e)=>this._onCopyCut(t,e)));this.listenTo(e,"cut",((t,e)=>this._onCopyCut(t,e)));this.listenTo(t.model,"insertContent",((t,e)=>this._onInsertContent(t,...e)),{priority:"high"});this.decorate("_replaceTableSlotCell")}_onCopyCut(t,e){const n=this.editor.plugins.get(nj);if(!n.getSelectedTableCells()){return}if(t.name=="cut"&&this.editor.isReadOnly){return}e.preventDefault();t.stop();const o=this.editor.data;const i=this.editor.editing.view.document;const r=o.toView(n.getSelectionAsFragment());i.fire("clipboardOutput",{dataTransfer:e.dataTransfer,content:r,method:t.name})}_onInsertContent(t,e,n){if(n&&!n.is("documentSelection")){return}const o=this.editor.model;const i=this.editor.plugins.get(nR);let r=ij(e,o);if(!r){return}const s=wO(o.document.selection);if(!s.length){VO(r,i);return}t.stop();o.change((t=>{const e={width:i.getColumns(r),height:i.getRows(r)};const n=rj(s,e,t,i);const o=n.lastRow-n.firstRow+1;const a=n.lastColumn-n.firstColumn+1;const c={startRow:0,startColumn:0,endRow:Math.min(o,e.height)-1,endColumn:Math.min(a,e.width)-1};r=NO(r,c,t);const l=s[0].findAncestor("table");const d=this._replaceSelectedCellsWithPasted(r,e,l,n,t);if(this.editor.plugins.get("TableSelection").isEnabled){const e=vO(d.map((e=>t.createRangeOn(e))));t.setSelection(e)}else{t.setSelection(d[0],0)}}))}_replaceSelectedCellsWithPasted(t,e,n,o,i){const{width:r,height:s}=e;const a=aj(t,r,s);const c=[...new KL(n,{startRow:o.firstRow,endRow:o.lastRow,startColumn:o.firstColumn,endColumn:o.lastColumn,includeAllSlots:true})];const l=[];let d;for(const t of c){const{row:e,column:n}=t;if(n===o.firstColumn){d=t.getPositionBefore()}const c=e-o.firstRow;const u=n-o.firstColumn;const h=a[c%s][u%r];const f=h?i.cloneElement(h):null;const g=this._replaceTableSlotCell(t,f,d,i);if(!g){continue}OO(g,e,n,o.lastRow,o.lastColumn,i);l.push(g);d=i.createPositionAfter(g)}const u=parseInt(n.getAttribute("headingRows")||0);const h=parseInt(n.getAttribute("headingColumns")||0);const f=o.firstRow<u&&u<=o.lastRow;const g=o.firstColumn<h&&h<=o.lastColumn;if(f){const t={first:o.firstColumn,last:o.lastColumn};const e=lj(n,u,t,i,o.firstRow);l.push(...e)}if(g){const t={first:o.firstRow,last:o.lastRow};const e=dj(n,h,t,i);l.push(...e)}return l}_replaceTableSlotCell(t,e,n,o){const{cell:i,isAnchor:r}=t;if(r){o.remove(i)}if(!e){return null}o.insert(e,n);return e}}function ij(t,e){if(!t.is("documentFragment")&&!t.is("element")){return null}if(t.is("element","table")){return t}if(t.childCount==1&&t.getChild(0).is("element","table")){return t.getChild(0)}const n=e.createRangeIn(t);for(const t of n.getItems()){if(t.is("element","table")){const o=e.createRange(n.start,e.createPositionBefore(t));if(e.hasContent(o,{ignoreWhitespaces:true})){return null}const i=e.createRange(e.createPositionAfter(t),n.end);if(e.hasContent(i,{ignoreWhitespaces:true})){return null}return t}}return null}function rj(t,e,n,o){const i=t[0].findAncestor("table");const r=AO(t);const s=CO(t);const a={firstColumn:r.first,lastColumn:r.last,firstRow:s.first,lastRow:s.last};const c=t.length===1;if(c){a.lastRow+=e.height-1;a.lastColumn+=e.width-1;sj(i,a.lastRow+1,a.lastColumn+1,o)}if(c||!_O(t,o)){cj(i,a,n)}else{a.lastRow=UO(i,a);a.lastColumn=HO(i,a)}return a}function sj(t,e,n,o){const i=o.getColumns(t);const r=o.getRows(t);if(n>i){o.insertColumns(t,{at:i,columns:n-i})}if(e>r){o.insertRows(t,{at:r,rows:e-r})}}function aj(t,e,n){const o=new Array(n).fill(null).map((()=>new Array(e).fill(null)));for(const{column:e,row:n,cell:i}of new KL(t)){o[n][e]=i}return o}function cj(t,e,n){const{firstRow:o,lastRow:i,firstColumn:r,lastColumn:s}=e;const a={first:o,last:i};const c={first:r,last:s};dj(t,r,a,n);dj(t,s+1,a,n);lj(t,o,c,n);lj(t,i+1,c,n,o)}function lj(t,e,n,o,i=0){if(e<1){return}const r=BO(t,e,i);const s=r.filter((({column:t,cellWidth:e})=>uj(t,e,n)));return s.map((({cell:t})=>zO(t,e,o)))}function dj(t,e,n,o){if(e<1){return}const i=PO(t,e);const r=i.filter((({row:t,cellHeight:e})=>uj(t,e,n)));return r.map((({cell:t,column:n})=>LO(t,n,e,o)))}function uj(t,e,n){const o=t+e-1;const{first:i,last:r}=n;const s=t>=i&&t<=r;const a=t<i&&o>=i;return s||a}class hj extends Un{static get pluginName(){return"TableKeyboard"}static get requires(){return[nj]}init(){const t=this.editor.editing.view;const e=t.document;this.editor.keystrokes.set("Tab",((...t)=>this._handleTabOnSelectedTable(...t)),{priority:"low"});this.editor.keystrokes.set("Tab",this._getTabHandler(true),{priority:"low"});this.editor.keystrokes.set("Shift+Tab",this._getTabHandler(false),{priority:"low"});this.listenTo(e,"arrowKey",((...t)=>this._onArrowKey(...t)),{context:"table"})}_handleTabOnSelectedTable(t,e){const n=this.editor;const o=n.model.document.selection;const i=o.getSelectedElement();if(!i||!i.is("element","table")){return}e();n.model.change((t=>{t.setSelection(t.createRangeIn(i.getChild(0).getChild(0)))}))}_getTabHandler(t){const e=this.editor;return(n,o)=>{const i=e.model.document.selection;let r=bO(i)[0];if(!r){r=this.editor.plugins.get("TableSelection").getFocusCell()}if(!r){return}o();const s=r.parent;const a=s.parent;const c=a.getChildIndex(s);const l=s.getChildIndex(r);const d=l===0;if(!t&&d&&c===0){e.model.change((t=>{t.setSelection(t.createRangeOn(a))}));return}const u=this.editor.plugins.get("TableUtils");const h=l===s.childCount-1;const f=c===u.getRows(a)-1;if(t&&f&&h){e.execute("insertTableRowBelow");if(c===u.getRows(a)-1){e.model.change((t=>{t.setSelection(t.createRangeOn(a))}));return}}let g;if(t&&h){const t=a.getChild(c+1);g=t.getChild(0)}else if(!t&&d){const t=a.getChild(c-1);g=t.getChild(t.childCount-1)}else{g=s.getChild(l+(t?1:-1))}e.model.change((t=>{t.setSelection(t.createRangeIn(g))}))}}_onArrowKey(t,e){const n=this.editor;const o=e.keyCode;const i=dd(o,n.locale.contentLanguageDirection);const r=this._handleArrowKeys(i,e.shiftKey);if(r){e.preventDefault();e.stopPropagation();t.stop()}}_handleArrowKeys(t,e){const n=this.editor.model;const o=n.document.selection;const i=["right","down"].includes(t);const r=kO(o);if(r.length){let n;if(e){n=this.editor.plugins.get("TableSelection").getFocusCell()}else{n=i?r[r.length-1]:r[0]}this._navigateFromCellInDirection(n,t,e);return true}const s=o.focus.findAncestor("tableCell");if(!s){return false}if(e&&!o.isCollapsed&&o.isBackward==i){return false}if(this._isSelectionAtCellEdge(o,s,i)){this._navigateFromCellInDirection(s,t,e);return true}return false}_isSelectionAtCellEdge(t,e,n){const o=this.editor.model;const i=this.editor.model.schema;const r=n?t.getLastPosition():t.getFirstPosition();if(!i.getLimitElement(r).is("element","tableCell")){const t=o.createPositionAt(e,n?"end":0);return t.isTouching(r)}const s=o.createSelection(r);o.modifySelection(s,{direction:n?"forward":"backward"});return r.isEqual(s.focus)}_navigateFromCellInDirection(t,e,n=false){const o=this.editor.model;const i=t.findAncestor("table");const r=[...new KL(i,{includeAllSlots:true})];const{row:s,column:a}=r[r.length-1];const c=r.find((({cell:e})=>e==t));let{row:l,column:d}=c;switch(e){case"left":d--;break;case"up":l--;break;case"right":d+=c.cellWidth;break;case"down":l+=c.cellHeight;break}const u=l<0||l>s;const h=d<0&&l<=0;const f=d>a&&l>=s;if(u||h||f){o.change((t=>{t.setSelection(t.createRangeOn(i))}));return}if(d<0){d=n?0:a;l--}else if(d>a){d=n?a:0;l++}const g=r.find((t=>t.row==l&&t.column==d)).cell;const m=["right","down"].includes(e);const p=this.editor.plugins.get("TableSelection");if(n&&p.isEnabled){const e=p.getAnchorCell()||t;p.setCellSelection(e,g)}else{const t=o.createPositionAt(g,m?0:"end");o.change((e=>{e.setSelection(t)}))}}}class fj extends Th{constructor(t){super(t);this.domEventType=["mousemove","mouseleave"]}onDomEvent(t){this.fire(t.type,t)}}class gj extends Un{static get pluginName(){return"TableMouse"}static get requires(){return[nj]}init(){const t=this.editor;t.editing.view.addObserver(fj);this._enableShiftClickSelection();this._enableMouseDragSelection()}_enableShiftClickSelection(){const t=this.editor;let e=false;const n=t.plugins.get(nj);this.listenTo(t.editing.view.document,"mousedown",((o,i)=>{if(!this.isEnabled||!n.isEnabled){return}if(!i.domEvent.shiftKey){return}const r=n.getAnchorCell()||bO(t.model.document.selection)[0];if(!r){return}const s=this._getModelTableCellFromDomEvent(i);if(s&&mj(r,s)){e=true;n.setCellSelection(r,s);i.preventDefault()}}));this.listenTo(t.editing.view.document,"mouseup",(()=>{e=false}));this.listenTo(t.editing.view.document,"selectionChange",(t=>{if(e){t.stop()}}),{priority:"highest"})}_enableMouseDragSelection(){const t=this.editor;let e,n;let o=false;let i=false;const r=t.plugins.get(nj);this.listenTo(t.editing.view.document,"mousedown",((t,n)=>{if(!this.isEnabled||!r.isEnabled){return}if(n.domEvent.shiftKey||n.domEvent.ctrlKey||n.domEvent.altKey){return}e=this._getModelTableCellFromDomEvent(n)}));this.listenTo(t.editing.view.document,"mousemove",((t,s)=>{if(!s.domEvent.buttons){return}if(!e){return}const a=this._getModelTableCellFromDomEvent(s);if(a&&mj(e,a)){n=a;if(!o&&n!=e){o=true}}if(!o){return}i=true;r.setCellSelection(e,n);s.preventDefault()}));this.listenTo(t.editing.view.document,"mouseup",(()=>{o=false;i=false;e=null;n=null}));this.listenTo(t.editing.view.document,"selectionChange",(t=>{if(i){t.stop()}}),{priority:"highest"})}_getModelTableCellFromDomEvent(t){const e=t.target;const n=this.editor.editing.view.createPositionAt(e,0);const o=this.editor.editing.mapper.toModelPosition(n);const i=o.parent;return i.findAncestor("tableCell",{includeSelf:true})}}function mj(t,e){return t.parent.parent==e.parent.parent}var pj=n(66);var kj={injectType:"singletonStyleTag",attributes:{"data-cke":true}};kj.insert="head";kj.singleton=true;var bj=Sb()(pj["a"],kj);var wj=pj["a"].locals||{};class Cj extends Un{static get requires(){return[jR,QR,nj,gj,hj,oj,rD]}static get pluginName(){return"Table"}}function Aj(t){const e=t.getSelectedElement();if(e&&vj(e)){return e}return null}function _j(t){let e=t.getFirstPosition().parent;while(e){if(e.is("element")&&vj(e)){return e}e=e.parent}return null}function vj(t){return!!t.getCustomProperty("table")&&kE(t)}class yj extends Un{static get requires(){return[eT]}static get pluginName(){return"TableToolbar"}afterInit(){const t=this.editor;const e=t.t;const n=t.plugins.get(eT);const o=t.config.get("table.contentToolbar");const i=t.config.get("table.tableToolbar");if(o){n.register("tableContent",{ariaLabel:e("Table toolbar"),items:o,getRelatedElement:_j})}if(i){n.register("table",{ariaLabel:e("Table toolbar"),items:i,getRelatedElement:Aj})}}}class xj extends Pv{}xj.builtinPlugins=[Zv,oy,kx,yx,Vx,tE,qD,fI,bI,OI,tT,NT,GT,SM,HM,VS,eN,BN,zN,DS,FN,GN,zz,wP,XP,VI,LL,Cj,yj,Jy];var Ej=e["default"]=xj}])["default"]}));
//# sourceMappingURL=ckeditor.js.map