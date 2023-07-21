export interface UserState {
    account: string;
    phone: string;
    name: string;
    email: string;
    memo: string;
    is_super_admin: string;
    role: string;
    access_token: string;
    refresh_at: number;
    refresh_token: string;
    auths: string[];
  }
  