export interface KlarnaKcoPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
