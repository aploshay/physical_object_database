describe "root" do
  it "routes to physical_objects#index" do
    expect(get("/")).to route_to("physical_objects#index")
  end
end

describe "batches" do
  it "routes to workflow_history" do
    expect(get("/batches/:id/workflow_history")).to be_routable
  end
  it "routes to add_bin" do
    expect(patch("/batches/id/add_bin")).to be_routable
  end
  it "routes to remove_bin" do
    expect(post("/batches/id/remove_bin")).to be_routable
  end
end

describe "bins" do
  it "routes to add_barcode_item" do
    expect(post("/bins/:id/add_barcode_item")).to be_routable
  end

  it "routes to unbatch" do
    expect(post("/bins/:id/unbatch")).to be_routable
  end

  it "routes to seal" do
    expect(patch("/bins/:id/seal")).to be_routable
  end

  it "routes to unseal" do
    expect(patch("/bins/:id/unseal")).to be_routable
  end

  it "routes to show_boxes" do
    expect(get("/bins/:id/show_boxes")).to be_routable
  end

  it "routes to assign_boxes" do
    expect(patch("/bins/:id/assign_boxes")).to be_routable
  end

  it "routes to workflow_history" do
    expect(get("/bins/:id/workflow_history")).to be_routable
  end

end

describe "boxes" do
  it "routes to edit" do
    expect(get("/boxes/:id/edit")).to be_routable
  end

  it "routes to add_barcode_item" do
    expect(post("/boxes/:id/add_barcode_item")).to be_routable
  end

  it "routes to unbin" do
    expect(post("/boxes/:id/unbin")).to be_routable
  end

  it "routes to index through bins" do
    expect(post("/bins/:bin_id/boxes")).to be_routable
  end

  it "routes to new through bins" do
    expect(get("/bins/:bin_id/boxes/new")).to be_routable
  end

  it "routes to create through bins" do
    expect(post("/bins/:bin_id/boxes")).to be_routable
  end
end

describe "group keys" do
  it "routes to index" do
    expect(get "/group_keys").to route_to action: "index", controller: "group_keys"
  end
  it "routes to show" do
    expect(get "/group_keys/:id").to route_to action: "show", controller: "group_keys", id: ":id"
  end
  it "routes to new" do
    expect(get "/group_keys/new").to route_to action: "new", controller: "group_keys"
  end
  it "routes to edit" do
    expect(get("/group_keys/:id/edit")).to be_routable
  end
  it "routes to create" do
    expect(post("/group_keys")).to route_to action: "create", controller: "group_keys"
  end 
  it "routes to update" do
    expect(patch("/group_keys/:id")).to route_to action: "update", controller: "group_keys", id: ":id"
  end
  it "routes to destroy" do
    expect(delete("/group_keys/:id")).to route_to action: "destroy", controller: "group_keys", id: ":id"
  end
  it "routes to reorder" do
    expect(patch("/group_keys/:id/reorder")).to route_to action: "reorder", controller: "group_keys", id: ":id"
  end

  it "routes to physical_object new through group_keys" do
    expect(get("/group_keys/:group_key_id/physical_objects/new")).to be_routable
  end
end

describe "picklist_specifications" do
  it "routes to tm_form" do
    expect(get("/picklist_specifications/tm_form")).to be_routable
  end
  it "routes to query" do
    expect(get("/picklist_specifications/:id/query")).to be_routable
  end
  it "routes to picklist_list" do
    expect(get("/picklist_specifications/picklist_list")).to be_routable
  end
  it "routes to new_picklist" do
    expect(get("/picklist_specifications/new_picklist")).to be_routable
  end
  it "routes to query_add" do
    expect(patch("/picklist_specifications/:id/query_add")).to be_routable
  end
  it "routes to update" do
    expect(post("/picklist_specifications/:id")).to be_routable
  end
end

describe "picklists" do
  it "does not route to index" do
    expect(get("/picklists")).not_to be_routable
  end
  it "routes to patch pack_list on collection" do
    expect(patch("/picklists/pack_list")).to be_routable
  end
  it "routes to get pack_list on collection" do
    expect(get("/picklists/pack_list")).to be_routable
  end
  it "routes to patch pack_list on member" do
    expect(patch("/picklists/1/pack_list")).to be_routable
  end
  it "routes to get pack_list on member" do
    expect(get("/picklists/1/pack_list")).to be_routable
  end
  it "routes to assign_to_container" do
    expect(patch("/picklists/assign_to_container")).to be_routable
  end
  it "routes to remove_from_container" do
    expect(patch("/picklists/remove_from_container")).to be_routable
  end
end

describe "returns" do
  it "routes to index" do
    expect(get("/returns")).to be_routable
  end
  it "routes to returns_bins" do
    expect(get("/returns/:id/return_bins")).to be_routable
  end
  it "routes to unload_bin" do
    expect(patch("/returns/:id/unload_bin")).to be_routable
  end
  it "routes to return_bin" do
    expect(get("/returns/:id/return_bin")).to be_routable
  end
  it "routes to physical_object_missing" do
    expect(get("/returns/:id/physical_object_missing")).to be_routable
  end
  it "routes to physical_object_returned" do
    expect(patch("/returns/:id/physical_object_returned")).to be_routable
  end
  it "routes to bin_unpacked" do
    expect(patch("/returns/:id/bin_unpacked")).to be_routable
  end
  it "routes to batch_complete" do
    expect(patch("/returns/:id/batch_complete")).to be_routable
  end
end

describe "search" do
  it "routes to advanced_search" do
    expect(post("/search/advanced_search")).to be_routable
  end
  it "routes to search_results" do
    expect(post("/search/search_results")).to be_routable
  end
end

describe "status_templates" do
  it "routes to index" do
    expect(get("/status_templates")).to be_routable
  end
end


describe "signin" do
  it "routes to sessions#new" do
    expect(get("/signin")).to route_to("sessions#new")
  end
end

describe "signout" do
  it "routes to sessions#destroy" do
    expect(delete("/signout")).to route_to("sessions#destroy")
  end
end

describe "sessions" do
    it "routes to new" do
      expect(get("/sessions/new")).to be_routable
    end
    it "routes to destroy" do
      expect(delete("/sessions/:id")).to be_routable
    end
    it "routest to validate_login" do
      expect(get("/sessions/validate_login")).to be_routable
    end
end

describe "quality_control" do
  it "routes to QC index" do
    expect(get("/quality_control/")).to be_routable
  end
  it "routes to QC#decide" do
    expect(patch("/quality_control/decide/:id")).to route_to("quality_control#decide", id: ':id')
  end
end

