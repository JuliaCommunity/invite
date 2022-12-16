using GitHub
using Airtable

AIR_TABLE_KEY = ARGS[1]
AIR_TABLE_BASE = ARGS[2]
AIR_TABLE_NAME = ARGS[3]

AUTH_TOKEN = ARGS[4]

key = Airtable.Credential(AIR_TABLE_KEY)

tab = AirTable(AIR_TABLE_NAME, AirBase(AIR_TABLE_BASE))

myauth = GitHub.authenticate(AUTH_TOKEN)

for row in Airtable.query(tab)
    
    # Invite people to the JuliaCommunity GitHub org, which has the ID = 6883862 (only visible via the API)
    try 
        response = invitations(auth=myauth, "JuliaCommunity", Dict("email"=>row[:Email],"role"=>"direct_member","team_ids"=>[6883862]))
    catch
        print("Failed to send invite, deleting record from AirTable")
        Airtable.delete!(row)
    end

    # Assuming successful, we need to remove the row
    Airtable.delete!(row)
    break
end
