Rails.application.configure do 
  config.mf_hanbai_portal = {
    staff: { host: "mf-hanbai-portal.example.com", path: "" },
    admin: { host: "mf-hanbai-portal.example.com", path: "admin" },
    customer: { host: "example.com", path: "mypage" },
  }
end
